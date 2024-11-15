# Extends env file (`$nu.env-path` `C:\Users\USER\AppData\Roaming\nushell\env.nu`)
# Sourced there through `source `~\.config\nushell\env.nu``

const cfgpath = '~\.config\nushell'
const nuscriptspath = $'($cfgpath)\nu_scripts'
const nuscriptspath2 = $'($cfgpath)\nu_scripts\modules'

$env.NU_LIB_DIRS = [...$env.NU_LIB_DIRS $nuscriptspath ]
$env.NU_LIB_DIRS = [...$env.NU_LIB_DIRS $nuscriptspath2 ]

def is-old [filepath: path] {
	not ($filepath | path exists) or (ls $filepath | get modified | ($in | length) == 1 and (date now) - $in.0 > 1day)
}
def call-if-old [filepath: path, fn: closure] {
	if (is-old $filepath) {
		do $fn $filepath
	}
}

mkdir $nu.cache-dir
call-if-old $'($nu.cache-dir)/starship-init.nu' {|filepath| starship init nu | save -f $filepath }
#call-if-old $'($nu.cache-dir)/pueue-completions.nu' {|filepath| pueue completions nushell | save -f $filepath }
#call-if-old $'($nu.cache-dir)/starship-completions.nu' {|filepath| starship completions nushell | save -f $filepath }

#zoxide init nushell | save -f ~/.zoxide.nu
