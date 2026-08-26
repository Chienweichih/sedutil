# sedutil OPAL Test Scripts

## Directory Layout

```
TEST/
├── common/                     # Shared library, sourced by the other scripts via a relative path
│   ├── OPAL_CONFIG.sh          # Constants defined by the TCG OPAL Core spec (Tokens/UIDs/MethodIDs)
│   ├── SEDUTIL_CONFIG.sh       # Constants defined by sedutil-cli itself (SP index, Anybody UID), not the spec
│   ├── OPAL_UTILS.sh           # Generic sedutil-cli --rawCmd wrapper functions
│   ├── OPAL_CNL_UTILS.sh       # CNL preconfiguration procedures
│   └── OPAL_TEST_INIT.sh       # Locates sedutil-cli, guards against running on the system disk, fetches MSID
├── OPAL_TEST.sh                # NVMe: set up a Locking Range, then test read/write
├── OPAL_SPF06.sh                # SPF06 case
├── OPAL_CNL_MAIN.sh            # Full CNL preconfiguration flow
├── OPAL_CNL_METHOD_TEST.sh     # Assign / Deassign method test
└── SATA/                       # SATA-specific (power-cycle test needs to run in stages)
    ├── OPAL_TEST.sh
    ├── OPAL_TEST-1_SETUP_LR.sh
    ├── OPAL_TEST-2_WRITE.sh
    ├── OPAL_TEST-3_READ.sh
    ├── OPAL_TEST-4_REVERT.sh
    └── OPAL_TEST-SET_GET_LR.sh
```

## Usage

```bash
./OPAL_TEST.sh [DEVICE] [PSID]
```

If no arguments are given, each script falls back to its own default device:
`/dev/nvme0n1` for the NVMe scripts, `/dev/sda` for the SATA scripts.
Scripts can be run from any working directory; there's no need to `cd` into `TEST/` first.

The SATA power-cycle test runs in stages:

```bash
SATA/OPAL_TEST-1_SETUP_LR.sh [DEVICE]   # Set up the Locking Range
SATA/OPAL_TEST-2_WRITE.sh    [DEVICE]   # Write data, then manually power-cycle the device
SATA/OPAL_TEST-3_READ.sh     [DEVICE]   # Read back and compare after reboot
SATA/OPAL_TEST-4_REVERT.sh   [DEVICE]   # revertTPer and clean up temp files
```

## sedutil-cli Lookup Order

`common/OPAL_TEST_INIT.sh` searches for `sedutil-cli` in this order:

1. `$SEDUTIL_CLI` environment variable (explicit override)
2. One directory above `TEST/` (the repo root — i.e. this project's own build)
3. `./sedutil-cli` in the current working directory
4. `$PATH` (checked last, so a system-wide install never shadows this project's own build)

If none of the four are found, the script exits with an error explaining how to point it at a binary.

## Design Notes

- **No `set -e`.** These scripts initialize/write/revert real hardware. Adding
  `-e` means a single non-fatal command returning non-zero (e.g. disabling a
  Locking Range that's already disabled) could abort the script mid-sequence
  and leave the device in a half-configured state — worse than "finished, but
  you need to read the output to judge pass/fail." If you want to enable it,
  first confirm the exit-code semantics of every `sedutil-cli` command under
  every precondition you rely on.
- **The files under `common/` have include guards** (e.g.
  `OPAL_CONFIG_SH_INCLUDED`), so being sourced multiple times by different
  top-level scripts in the same run won't redefine anything.
- **Files under `common/` are only ever `source`d, so they don't need the
  executable bit.** Only the scripts under `TEST/` and `TEST/SATA/` that are
  meant to be run directly need `chmod +x`.
