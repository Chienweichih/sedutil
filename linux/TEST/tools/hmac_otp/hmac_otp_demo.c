#include <stdio.h>

#define SHA256_HMAC_IMPLEMENTATION
#include "hmac_sha256.h"

#define SECRET_LEN  16
#define COUNTER_LEN 4

int main(void)
{
    // Secret sent when the SED is unlocked
    unsigned char secret[SECRET_LEN] = { 0 };
    // Counter that gets incremented at each heartbeat
    unsigned char counter[COUNTER_LEN] = { 0 };

    // For this example:
    // - SECRET  = 0x01020304050607081112131415161718
    // - COUNTER = 0x00000001
    for (unsigned int i = 0; i < 8; ++i) {
        secret[i] = i + 1;
    }
    for (unsigned int i = 0; i < 8; ++i) {
        secret[i + 8] = i + 16 + 1;
    }
    counter[COUNTER_LEN - 1] = 1;

    printf("SECRET\t: 0x");
    for (unsigned int i = 0; i < SECRET_LEN; ++i) {
        printf("%02x", secret[i]);
    }
    printf("\n");

    printf("COUNTER\t: 0x");
    for (unsigned int i = 0; i < COUNTER_LEN; ++i) {
        printf("%02x", counter[i]);
    }
    printf("\n");

    // One-shot HMAC-SHA256(key = secret, msg = counter)
    // No malloc, no padding/XOR bookkeeping, no OpenSSL — the header
    // does the ipad/opad + double-SHA256 internally.
    unsigned char hash[SHA256_DIGEST_SIZE];
    hmac_sha256(secret, SECRET_LEN, counter, COUNTER_LEN, hash);

    printf("HMAC\t: 0x");
    for (unsigned int i = 0; i < SHA256_DIGEST_SIZE; ++i) {
        printf("%02x", hash[i]);
    }
    printf("\n");

    printf("OTP\t: 0x");
    for (unsigned int i = SHA256_DIGEST_SIZE - 8; i < SHA256_DIGEST_SIZE; ++i) {
        printf("%02x", hash[i]);
    }
    printf("\n");

    return 0;
}

/*
 * Streaming-style equivalent, useful if secret/counter arrive in
 * separate buffers (e.g. one from flash, one from a live register) and
 * you don't want to concatenate them yourself:
 *
 *   hmac_sha256_ctx ctx;
 *   hmac_sha256_init(&ctx, secret, SECRET_LEN);
 *   hmac_sha256_update(&ctx, counter, COUNTER_LEN);
 *   hmac_sha256_final(&ctx, hash);
 */
