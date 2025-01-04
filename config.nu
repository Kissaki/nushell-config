# Extends config file (`$nu.config-path` `C:\Users\USER\AppData\Roaming\nushell\config.nu`)
# Sourced there through `source `~\.config\nushell\config.nu``

$env.config.show_banner = false
$env.config.rm.always_trash = true
# Change display_output to table so tables are not automatically expanded (`table -e`)
$env.config.hooks.display_output = 'table'
#$env.config.filesize.metric = true
#$env.config.shell_integration = true
#$env.config.highlight_resolved_externals = true
$env.config.table.footer_inheritance = true # render footer in parent table if child is big enough (extended table option)
$env.config.footer_mode = 21 # always, never, number_of_rows, auto
# Never show expanded table content by default (infeasible especially with long content like $env.PATH)
$env.config.hooks.display_output = 'table'
# Use a uniform, ordered yyyy-MM-dd… date time format
$env.config.datetime_format.normal = '%F %T %z'

source `config-nusc-completions.nu`
source `config-aliases-commands.nu`

source `config-menus.nu`

$env.EDITOR = 'micro'

source nav.nu

#use job.nu
#use up.nu
use $'($nu.cache-dir)/starship-init.nu'
#use $'($nu.cache-dir)/starship-completions.nu' *
#use $'($nu.cache-dir)/pueue-completions.nu' *
use 'nu_scripts/modules/background_task/task.nu'

# zoxide - path navigation history and fuzzy search - z + zi - A smarter cd command
#source ~/.zoxide.nu

# nu_scripts
source `./nu_scripts/sourced/misc/base64_encode.nu`
