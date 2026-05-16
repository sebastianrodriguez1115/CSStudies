import assert from "node:assert/strict";
import test from "node:test";

import { BASE62_ALPHABET, buildApp } from "../src/app.ts";

test("health endpoint returns ok", async (t) => {
  const app = buildApp();
  t.after(() => app.close());

  const response = await app.inject({ method: "GET", url: "/health" });

  assert.equal(response.statusCode, 200);
  assert.deepEqual(response.json(), { status: "ok" });
});

test("shorten creates a base62 code and redirects", async (t) => {
  const app = buildApp();
  t.after(() => app.close());

  const response = await app.inject({
    method: "POST",
    url: "/api/v1/urls",
    headers: { host: "sho.rt" },
    payload: { long_url: "https://example.com/deep/path" },
  });

  assert.equal(response.statusCode, 201);
  const body = response.json() as { short_code: string; short_url: string };
  assert.equal(body.short_code.length, 7);
  assert.ok([...body.short_code].every((char) => BASE62_ALPHABET.includes(char)));
  assert.equal(body.short_url, `http://sho.rt/${body.short_code}`);

  const redirect = await app.inject({
    method: "GET",
    url: `/${body.short_code}`,
  });

  assert.equal(redirect.statusCode, 302);
  assert.equal(redirect.headers.location, "https://example.com/deep/path");
});

test("random code collision retries", async (t) => {
  const codes = ["aaaaaaa", "aaaaaaa", "bbbbbbb"];
  const app = buildApp({
    codeGenerator: () => {
      const code = codes.shift();
      assert.ok(code);
      return code;
    },
  });
  t.after(() => app.close());

  const first = await app.inject({
    method: "POST",
    url: "/api/v1/urls",
    payload: { long_url: "https://example.com/one" },
  });
  const second = await app.inject({
    method: "POST",
    url: "/api/v1/urls",
    payload: { long_url: "https://example.com/two" },
  });

  assert.equal(first.statusCode, 201);
  assert.equal(first.json<{ short_code: string }>().short_code, "aaaaaaa");
  assert.equal(second.statusCode, 201);
  assert.equal(second.json<{ short_code: string }>().short_code, "bbbbbbb");
});

test("custom alias conflict returns 409", async (t) => {
  const app = buildApp();
  t.after(() => app.close());

  const first = await app.inject({
    method: "POST",
    url: "/api/v1/urls",
    payload: { long_url: "https://example.com/one", custom_alias: "team-link" },
  });
  const second = await app.inject({
    method: "POST",
    url: "/api/v1/urls",
    payload: { long_url: "https://example.com/two", custom_alias: "team-link" },
  });

  assert.equal(first.statusCode, 201);
  assert.equal(first.json<{ short_code: string }>().short_code, "team-link");
  assert.equal(second.statusCode, 409);
});

test("unknown short code returns 404", async (t) => {
  const app = buildApp();
  t.after(() => app.close());

  const response = await app.inject({ method: "GET", url: "/missing" });

  assert.equal(response.statusCode, 404);
});
