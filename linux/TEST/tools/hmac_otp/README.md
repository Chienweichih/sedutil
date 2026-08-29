# hmac_otp

Standalone HMAC-SHA256 based OTP generator. No external dependencies
(no OpenSSL, no library linking) — pure C99, single header.

Separate from the main sedutil codebase; not wired into its build system.

## Files

- `hmac_sha256.h` — SHA-256 + HMAC-SHA256 implementation (MIT licensed)
- `hmac_otp_demo.c` — example: HMAC(secret, counter) -> OTP
- `Makefile` — build the demo

## Build & run

```sh
make run
```

or manually:

```sh
gcc -o hmac_otp_demo hmac_otp_demo.c
./hmac_otp_demo
```

`make clean` removes the built binary.

## Use in your own code

```c
#define SHA256_HMAC_IMPLEMENTATION
#include "hmac_sha256.h"

uint8_t mac[32];
hmac_sha256(key, key_len, msg, msg_len, mac);
```

Only `#define SHA256_HMAC_IMPLEMENTATION` once, in one `.c` file.

When comparing a received MAC against an expected one, use `ct_memcmp()`
instead of `memcmp()` to avoid timing side-channels.
