# Extends env file (`$nu.env-path` `C:\Users\USER\AppData\Roaming\nushell\env.nu`)
# Sourced there through `source '~\nushell\env.nu'`

const cfgpath = '~\nushell'
const nuscriptspath = $'($cfgpath)\nu_scripts'

$env.NU_LIB_DIRS = [...$env.NU_LIB_DIRS $nuscriptspath ]

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

#zoxide init nushell | save -f ~/.zoxide.nu
