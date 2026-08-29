/*
 * hmac_sha256.h
 *
 * SPDX-License-Identifier: MIT
 *
 * Standalone, dependency-free SHA-256 and HMAC-SHA256 implementation.
 * Pure C99, no external library, no heap allocation, no libc string.h
 * requirement other than optional memset/memcpy (provided inline fallback
 * versions are included and can be swapped for your own if needed).
 *
 * Suitable for Arm Cortex-M / Cortex-A bare-metal firmware, RTOS tasks,
 * bootloaders, or any environment where you don't want to pull in a full
 * crypto library (mbedTLS, OpenSSL, etc.).
 *
 * Usage:
 *   #define SHA256_HMAC_IMPLEMENTATION
 *   #include "sha256_hmac.h"
 *
 * in exactly one .c file to generate the implementation; include the
 * header normally everywhere else.
 *
 * ---------------------------------------------------------------------
 * Quick API:
 *
 *   void sha256(const uint8_t *data, size_t len, uint8_t out[32]);
 *
 *   void hmac_sha256(const uint8_t *key, size_t key_len,
 *                     const uint8_t *msg, size_t msg_len,
 *                     uint8_t out[32]);
 *
 * Streaming API (if you need to feed data in chunks, e.g. DMA buffers):
 *
 *   sha256_ctx ctx;
 *   sha256_init(&ctx);
 *   sha256_update(&ctx, chunk1, len1);
 *   sha256_update(&ctx, chunk2, len2);
 *   sha256_final(&ctx, out);
 *
 *   hmac_sha256_ctx hctx;
 *   hmac_sha256_init(&hctx, key, key_len);
 *   hmac_sha256_update(&hctx, chunk1, len1);
 *   hmac_sha256_update(&hctx, chunk2, len2);
 *   hmac_sha256_final(&hctx, out);
 *
 * Constant-time comparison for verifying MACs:
 *
 *   int ct_memcmp(const void *a, const void *b, size_t len); // 0 == equal
 * ---------------------------------------------------------------------
 */

/*
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files, to deal in
 * the software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies, subject to including this notice in all copies or
 * substantial portions of the software. Provided "as is", without
 * warranty of any kind.
 */

#ifndef SHA256_HMAC_H
#define SHA256_HMAC_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SHA256_BLOCK_SIZE   64   /* bytes, 512 bits */
#define SHA256_DIGEST_SIZE  32   /* bytes, 256 bits */

typedef struct {
    uint32_t state[8];
    uint64_t bitlen;
    uint8_t  buffer[SHA256_BLOCK_SIZE];
    size_t   buffer_len;
} sha256_ctx;

typedef struct {
    sha256_ctx inner;
    sha256_ctx outer;
} hmac_sha256_ctx;

/* One-shot helpers */
void sha256(const uint8_t *data, size_t len, uint8_t out[SHA256_DIGEST_SIZE]);
void hmac_sha256(const uint8_t *key, size_t key_len,
                  const uint8_t *msg, size_t msg_len,
                  uint8_t out[SHA256_DIGEST_SIZE]);

/* Streaming SHA-256 */
void sha256_init(sha256_ctx *ctx);
void sha256_update(sha256_ctx *ctx, const uint8_t *data, size_t len);
void sha256_final(sha256_ctx *ctx, uint8_t out[SHA256_DIGEST_SIZE]);

/* Streaming HMAC-SHA256 */
void hmac_sha256_init(hmac_sha256_ctx *ctx, const uint8_t *key, size_t key_len);
void hmac_sha256_update(hmac_sha256_ctx *ctx, const uint8_t *data, size_t len);
void hmac_sha256_final(hmac_sha256_ctx *ctx, uint8_t out[SHA256_DIGEST_SIZE]);

/* Constant-time buffer compare: returns 0 if equal, nonzero otherwise.
 * Use this instead of memcmp() when checking a received MAC against an
 * expected one, to avoid timing side-channels. */
int ct_memcmp(const void *a, const void *b, size_t len);

#ifdef __cplusplus
}
#endif

#endif /* SHA256_HMAC_H */


/* ======================================================================
 * IMPLEMENTATION
 * ==================================================================== */
#ifdef SHA256_HMAC_IMPLEMENTATION

/* ---- small local memset/memcpy so this file has zero libc dependency
 *      beyond stdint.h/stddef.h. Comment these out and use <string.h>
 *      if your toolchain's libc versions are preferred/optimized. ---- */
static void sha_memset(void *dst, int val, size_t n) {
    uint8_t *d = (uint8_t *)dst;
    while (n--) *d++ = (uint8_t)val;
}
static void sha_memcpy(void *dst, const void *src, size_t n) {
    uint8_t *d = (uint8_t *)dst;
    const uint8_t *s = (const uint8_t *)src;
    while (n--) *d++ = *s++;
}

/* ---- SHA-256 round constants (first 32 bits of fractional parts of
 *      cube roots of the first 64 primes) ---- */
static const uint32_t K256[64] = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

static uint32_t rotr32(uint32_t x, uint32_t n) {
    return (x >> n) | (x << (32 - n));
}

/* Process exactly one 64-byte block, updating state[8] */
static void sha256_transform(uint32_t state[8], const uint8_t block[SHA256_BLOCK_SIZE]) {
    uint32_t w[64];
    uint32_t a, b, c, d, e, f, g, h;
    int i;

    for (i = 0; i < 16; i++) {
        w[i] = ((uint32_t)block[i * 4]     << 24) |
               ((uint32_t)block[i * 4 + 1] << 16) |
               ((uint32_t)block[i * 4 + 2] << 8)  |
               ((uint32_t)block[i * 4 + 3]);
    }
    for (i = 16; i < 64; i++) {
        uint32_t s0 = rotr32(w[i-15], 7) ^ rotr32(w[i-15], 18) ^ (w[i-15] >> 3);
        uint32_t s1 = rotr32(w[i-2], 17) ^ rotr32(w[i-2], 19)  ^ (w[i-2] >> 10);
        w[i] = w[i-16] + s0 + w[i-7] + s1;
    }

    a = state[0]; b = state[1]; c = state[2]; d = state[3];
    e = state[4]; f = state[5]; g = state[6]; h = state[7];

    for (i = 0; i < 64; i++) {
        uint32_t S1 = rotr32(e, 6) ^ rotr32(e, 11) ^ rotr32(e, 25);
        uint32_t ch = (e & f) ^ ((~e) & g);
        uint32_t temp1 = h + S1 + ch + K256[i] + w[i];
        uint32_t S0 = rotr32(a, 2) ^ rotr32(a, 13) ^ rotr32(a, 22);
        uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
        uint32_t temp2 = S0 + maj;

        h = g; g = f; f = e; e = d + temp1;
        d = c; c = b; b = a; a = temp1 + temp2;
    }

    state[0] += a; state[1] += b; state[2] += c; state[3] += d;
    state[4] += e; state[5] += f; state[6] += g; state[7] += h;
}

void sha256_init(sha256_ctx *ctx) {
    ctx->state[0] = 0x6a09e667; ctx->state[1] = 0xbb67ae85;
    ctx->state[2] = 0x3c6ef372; ctx->state[3] = 0xa54ff53a;
    ctx->state[4] = 0x510e527f; ctx->state[5] = 0x9b05688c;
    ctx->state[6] = 0x1f83d9ab; ctx->state[7] = 0x5be0cd19;
    ctx->bitlen = 0;
    ctx->buffer_len = 0;
}

void sha256_update(sha256_ctx *ctx, const uint8_t *data, size_t len) {
    while (len > 0) {
        size_t take = SHA256_BLOCK_SIZE - ctx->buffer_len;
        if (take > len) take = len;

        sha_memcpy(ctx->buffer + ctx->buffer_len, data, take);
        ctx->buffer_len += take;
        data += take;
        len  -= take;
        ctx->bitlen += (uint64_t)take * 8;

        if (ctx->buffer_len == SHA256_BLOCK_SIZE) {
            sha256_transform(ctx->state, ctx->buffer);
            ctx->buffer_len = 0;
        }
    }
}

void sha256_final(sha256_ctx *ctx, uint8_t out[SHA256_DIGEST_SIZE]) {
    uint64_t bitlen = ctx->bitlen;
    size_t i = ctx->buffer_len;

    /* append 0x80 padding byte */
    ctx->buffer[i++] = 0x80;

    if (i > SHA256_BLOCK_SIZE - 8) {
        /* not enough room for length field, pad this block and flush */
        while (i < SHA256_BLOCK_SIZE) ctx->buffer[i++] = 0x00;
        sha256_transform(ctx->state, ctx->buffer);
        i = 0;
    }
    while (i < SHA256_BLOCK_SIZE - 8) ctx->buffer[i++] = 0x00;

    /* append 64-bit big-endian bit length */
    for (int j = 7; j >= 0; j--) {
        ctx->buffer[i++] = (uint8_t)(bitlen >> (j * 8));
    }
    sha256_transform(ctx->state, ctx->buffer);

    for (i = 0; i < 8; i++) {
        out[i * 4]     = (uint8_t)(ctx->state[i] >> 24);
        out[i * 4 + 1] = (uint8_t)(ctx->state[i] >> 16);
        out[i * 4 + 2] = (uint8_t)(ctx->state[i] >> 8);
        out[i * 4 + 3] = (uint8_t)(ctx->state[i]);
    }

    /* wipe sensitive state */
    sha_memset(ctx, 0, sizeof(*ctx));
}

void sha256(const uint8_t *data, size_t len, uint8_t out[SHA256_DIGEST_SIZE]) {
    sha256_ctx ctx;
    sha256_init(&ctx);
    sha256_update(&ctx, data, len);
    sha256_final(&ctx, out);
}

/* ---------------------------- HMAC-SHA256 ---------------------------- */

void hmac_sha256_init(hmac_sha256_ctx *ctx, const uint8_t *key, size_t key_len) {
    uint8_t key_block[SHA256_BLOCK_SIZE];
    uint8_t ipad[SHA256_BLOCK_SIZE];
    uint8_t opad[SHA256_BLOCK_SIZE];
    size_t i;

    sha_memset(key_block, 0, sizeof(key_block));

    if (key_len > SHA256_BLOCK_SIZE) {
        /* keys longer than the block size are hashed first */
        sha256(key, key_len, key_block); /* fills first 32 bytes, rest already 0 */
    } else {
        sha_memcpy(key_block, key, key_len);
    }

    for (i = 0; i < SHA256_BLOCK_SIZE; i++) {
        ipad[i] = key_block[i] ^ 0x36;
        opad[i] = key_block[i] ^ 0x5c;
    }

    sha256_init(&ctx->inner);
    sha256_update(&ctx->inner, ipad, SHA256_BLOCK_SIZE);

    sha256_init(&ctx->outer);
    sha256_update(&ctx->outer, opad, SHA256_BLOCK_SIZE);

    sha_memset(key_block, 0, sizeof(key_block));
    sha_memset(ipad, 0, sizeof(ipad));
    sha_memset(opad, 0, sizeof(opad));
}

void hmac_sha256_update(hmac_sha256_ctx *ctx, const uint8_t *data, size_t len) {
    sha256_update(&ctx->inner, data, len);
}

void hmac_sha256_final(hmac_sha256_ctx *ctx, uint8_t out[SHA256_DIGEST_SIZE]) {
    uint8_t inner_digest[SHA256_DIGEST_SIZE];
    sha256_final(&ctx->inner, inner_digest);

    sha256_update(&ctx->outer, inner_digest, SHA256_DIGEST_SIZE);
    sha256_final(&ctx->outer, out);

    sha_memset(inner_digest, 0, sizeof(inner_digest));
}

void hmac_sha256(const uint8_t *key, size_t key_len,
                  const uint8_t *msg, size_t msg_len,
                  uint8_t out[SHA256_DIGEST_SIZE]) {
    hmac_sha256_ctx ctx;
    hmac_sha256_init(&ctx, key, key_len);
    hmac_sha256_update(&ctx, msg, msg_len);
    hmac_sha256_final(&ctx, out);
}

int ct_memcmp(const void *a, const void *b, size_t len) {
    const uint8_t *pa = (const uint8_t *)a;
    const uint8_t *pb = (const uint8_t *)b;
    uint8_t diff = 0;
    size_t i;
    for (i = 0; i < len; i++) {
        diff |= (uint8_t)(pa[i] ^ pb[i]);
    }
    return (int)diff;
}

#endif /* SHA256_HMAC_IMPLEMENTATION */
