import { buildApp } from "./app.ts";

const port = Number.parseInt(process.env.PORT ?? "3000", 10);
const host = process.env.HOST ?? "127.0.0.1";

const app = buildApp();

await app.listen({ host, port });
