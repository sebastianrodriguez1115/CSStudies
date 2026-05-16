import { randomInt } from "node:crypto";
import Fastify, {
  type FastifyInstance,
  type FastifyReply,
  type FastifyRequest,
} from "fastify";

export const BASE62_ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
const DEFAULT_CODE_LENGTH = 7;
const MAX_CODE_GENERATION_ATTEMPTS = 10;
const RESERVED_ALIASES = new Set(["admin", "api", "docs", "health", "login", "openapi.json"]);
const ALIAS_PATTERN = /^[A-Za-z0-9_-]{3,32}$/;

export type CodeGenerator = () => string;

export type UrlRecord = {
  shortCode: string;
  longUrl: string;
  createdAt: Date;
  expiresAt: Date | null;
  custom: boolean;
};

type ShortenRequestBody = {
  long_url?: unknown;
  custom_alias?: unknown;
  expires_at?: unknown;
};

type CreateUrlInput = {
  longUrl: string;
  customAlias: string | null;
  expiresAt: Date | null;
};

class RequestValidationError extends Error {}
class AliasAlreadyExistsError extends Error {}
class CodeAllocationError extends Error {}

export class InMemoryUrlRepository {
  private readonly records = new Map<string, UrlRecord>();

  addIfAbsent(record: UrlRecord): boolean {
    if (this.records.has(record.shortCode)) {
      return false;
    }
    this.records.set(record.shortCode, record);
    return true;
  }

  get(shortCode: string): UrlRecord | null {
    return this.records.get(shortCode) ?? null;
  }
}

export class ShortenerService {
  constructor(
    private readonly repository: InMemoryUrlRepository,
    private readonly codeGenerator: CodeGenerator = generateBase62Code,
  ) {}

  create(input: CreateUrlInput): UrlRecord {
    if (input.expiresAt !== null && input.expiresAt.getTime() <= Date.now()) {
      throw new RequestValidationError("expires_at must be in the future");
    }

    if (input.customAlias !== null) {
      return this.createWithAlias(input);
    }

    for (let attempt = 0; attempt < MAX_CODE_GENERATION_ATTEMPTS; attempt += 1) {
      const record: UrlRecord = {
        shortCode: this.codeGenerator(),
        longUrl: input.longUrl,
        createdAt: new Date(),
        expiresAt: input.expiresAt,
        custom: false,
      };

      if (this.repository.addIfAbsent(record)) {
        return record;
      }
    }

    throw new CodeAllocationError("could not allocate a unique short code");
  }

  resolve(shortCode: string): UrlRecord | null {
    return this.repository.get(shortCode);
  }

  private createWithAlias(input: CreateUrlInput): UrlRecord {
    const customAlias = input.customAlias;
    if (customAlias === null) {
      throw new RequestValidationError("custom_alias is required");
    }
    if (!ALIAS_PATTERN.test(customAlias)) {
      throw new RequestValidationError("custom_alias must be 3-32 chars: letters, numbers, '-' or '_'");
    }
    if (RESERVED_ALIASES.has(customAlias)) {
      throw new RequestValidationError("custom_alias is reserved");
    }

    const record: UrlRecord = {
      shortCode: customAlias,
      longUrl: input.longUrl,
      createdAt: new Date(),
      expiresAt: input.expiresAt,
      custom: true,
    };

    if (!this.repository.addIfAbsent(record)) {
      throw new AliasAlreadyExistsError("custom_alias already exists");
    }

    return record;
  }
}

export type BuildAppOptions = {
  repository?: InMemoryUrlRepository;
  codeGenerator?: CodeGenerator;
};

export function buildApp(options: BuildAppOptions = {}): FastifyInstance {
  const repository = options.repository ?? new InMemoryUrlRepository();
  const service = new ShortenerService(repository, options.codeGenerator);
  const app = Fastify({ logger: false });

  app.get("/health", async () => ({ status: "ok" }));

  const shortenHandler = async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const input = parseShortenRequest(request.body);
      const record = service.create(input);

      return reply.status(201).send({
        short_url: `${externalBaseUrl(request)}/${record.shortCode}`,
        short_code: record.shortCode,
        expires_at: record.expiresAt?.toISOString() ?? null,
      });
    } catch (error) {
      if (error instanceof RequestValidationError) {
        return reply.status(400).send({ error: error.message });
      }
      if (error instanceof AliasAlreadyExistsError) {
        return reply.status(409).send({ error: error.message });
      }
      if (error instanceof CodeAllocationError) {
        return reply.status(503).send({ error: "temporary short code allocation failure" });
      }
      throw error;
    }
  };

  app.post("/api/v1/urls", shortenHandler);
  app.post("/shorten", shortenHandler);

  app.get("/:shortCode", async (request, reply) => {
    const { shortCode } = request.params as { shortCode: string };
    const record = service.resolve(shortCode);

    if (record === null) {
      return reply.status(404).send({ error: "short code not found" });
    }
    if (record.expiresAt !== null && record.expiresAt.getTime() <= Date.now()) {
      return reply.status(410).send({ error: "short code expired" });
    }

    return reply.status(302).header("location", record.longUrl).send();
  });

  return app;
}

export function generateBase62Code(length = DEFAULT_CODE_LENGTH): string {
  let code = "";
  for (let index = 0; index < length; index += 1) {
    code += BASE62_ALPHABET[randomInt(BASE62_ALPHABET.length)];
  }
  return code;
}

function parseShortenRequest(body: unknown): CreateUrlInput {
  if (body === null || typeof body !== "object") {
    throw new RequestValidationError("request body must be an object");
  }

  const payload = body as ShortenRequestBody;
  return {
    longUrl: parseHttpUrl(payload.long_url),
    customAlias: parseOptionalString(payload.custom_alias, "custom_alias"),
    expiresAt: parseOptionalDate(payload.expires_at, "expires_at"),
  };
}

function parseHttpUrl(value: unknown): string {
  if (typeof value !== "string") {
    throw new RequestValidationError("long_url is required");
  }

  try {
    const url = new URL(value);
    if (url.protocol !== "http:" && url.protocol !== "https:") {
      throw new RequestValidationError("long_url must use http or https");
    }
    return url.toString();
  } catch (error) {
    if (error instanceof RequestValidationError) {
      throw error;
    }
    throw new RequestValidationError("long_url must be a valid URL");
  }
}

function parseOptionalString(value: unknown, fieldName: string): string | null {
  if (value === undefined || value === null || value === "") {
    return null;
  }
  if (typeof value !== "string") {
    throw new RequestValidationError(`${fieldName} must be a string`);
  }
  return value;
}

function parseOptionalDate(value: unknown, fieldName: string): Date | null {
  if (value === undefined || value === null || value === "") {
    return null;
  }
  if (typeof value !== "string") {
    throw new RequestValidationError(`${fieldName} must be an ISO date string`);
  }

  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    throw new RequestValidationError(`${fieldName} must be a valid ISO date string`);
  }
  return parsed;
}

function externalBaseUrl(request: FastifyRequest): string {
  const forwardedProto = firstHeader(request.headers["x-forwarded-proto"]);
  const host = firstHeader(request.headers.host) ?? "localhost";
  return `${forwardedProto ?? "http"}://${host}`;
}

function firstHeader(value: string | string[] | undefined): string | undefined {
  return Array.isArray(value) ? value[0] : value;
}
