# Nushell Configuration

My personal [Nushell](https://www.nushell.sh/) configuration, integration, and scripts.

## Setup

Expected to be checked out to `~/nushell` and integrated as described in env.nu and config.nu

## Requirements / Expectations

* Installed [Starship](https://starship.rs/)
* Checked out [nu_scripts](https://github.com/nushell/nu_scripts/) (community scripts)

### nu_scripts

nu_scripts checkout to `nu_scripts`

```git
git clone --single-branch --depth 1 https://github.com/nushell/nu_scripts.git nu_scripts
```

## Technical Nushell Context

Nushell runs through a compile and run step. (This is in contrast to other, more traditional and dynamic languages.)

You can not `source`-include a nu file through a dynamically constructed path. Using `~` for home dir works, but not $'($basedir)/file.nu'.

The configuration is split into a two-step process:
Environment setup and configuration.
Dynamic file paths can be prepared in the environment setup and then be source-included during configuration.

1. Environment setup in `$nu.env-path`
2. Configuration setup in `$nu.config-path`

---

While using $env.APPDATA would be the technically correct place to put scripts and configuration, the default env.nu and config.nu files and defaults and new field introductions can change between Nushell versions.
The `config reset` command resets them to the (potentially new/updated) default.

The `~\AppData\Roaming\nushell` subpathing is inconvenient. So this setup takes a `~/nushell` approach.
