# Extends config file (`$nu.config-path` `C:\Users\USER\AppData\Roaming\nushell\config.nu`)
# Sourced there through `source `~\nushell\config.nu``

$env.config.show_banner = false
$env.config.rm.always_trash = true
#$env.config.filesize.metric = true
#$env.config.shell_integration = true
#$env.config.highlight_resolved_externals = true

source `config-integrations.nu`
source `config-aliases.nu`

source `config-menus.nu`

$env.EDITOR = `micro`

def get-subdirs [$p: string] {
  return (ls $p | where type == dir | get name | sort --ignore-case --natural | path basename)
}
def select-subpath [$basepath?: string] {
  let $base = ($basepath | default $env.PWD)

  mut $p = $base
  mut $open = true
  while $open {
    let subdir = (get-subdirs $p) | prepend ['.','..']
      | input list --fuzzy $'Navigating Directory (ansi magenta)($p)(ansi reset) - was ($env.PWD) - choose . to cd into, .. for parent'
    if $subdir == null {
      $p = null
      break
    } else if $subdir == '.' {
      $open = false
    } else if $subdir == '..' {
      $p = ($p | path dirname)
    } else {
      $p = ($p | path join $subdir)
    }
  }
  return $p
}
def --env cc [$basepath?: string] {
  let $p = select-subpath $basepath
  if $p != null {
    echo $'Changing to ($p)…'
    cd $p
    return $p
  }
}

def --env xx [$basepath?: string] {
  let $base = ($basepath | default $env.PWD)
  
  mut $paths = []
  mut $i = $base
  while true {
    $paths = ($paths | append $i)

    let $iBase = ($i | path dirname)
    if $i == $iBase {
      break
    }
    $i = $iBase
  }
  let $p = ($paths | input list --fuzzy $'Navigate to parent directory…')
  if $p != null {
    echo $'Changing to ($p)…'
    cd $p
  }
}

#use job.nu
#use up.nu
