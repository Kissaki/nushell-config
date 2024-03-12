# Extends config file (`$nu.config-path` `C:\Users\USER\AppData\Roaming\nushell\config.nu`)
# Sourced there through `source `~\nushell\config.nu``

$env.config.show_banner = false
$env.config.rm.always_trash = true
#$env.config.filesize.metric = true
#$env.config.shell_integration = true
#$env.config.highlight_resolved_externals = true

source `config-integrations.nu`
source `config-aliases.nu`
source `config-commands.nu`

source `config-menus.nu`

$env.EDITOR = `micro`

source nav.nu

#use job.nu
#use up.nu
