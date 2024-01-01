# Starship shell prompt
use ~/.cache/starship/init.nu

# zoxide - path navigation history and fuzzy search - z + zi - A smarter cd command
#source ~/.zoxide.nu

# nu_scripts
## custom selection of auto-completions
source '~/.cache/source-completions.nu'
source '~/.cache/source-completions_fish-generated.nu'
## scripts and commands
source `sourced/misc/base64_encode.nu`
