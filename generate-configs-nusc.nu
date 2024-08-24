let cfgpath = ($env.CURRENT_FILE | path dirname)
let out = $'($cfgpath)\config-nusc-completions.nu'

cd $'($cfgpath)/nu_scripts'
git pull --rebase

# custom completion sourcing - from nu_scripts
# broken 'winget'
# nu_scripts auto-completes:
## 'auto-generate' has script files, does not conform
## some have broken syntax; 'pass'
## (ls $'($nuscriptspath)\custom-completions\') | where type == 'dir' | get name | each { {dir: $in basename: ($in | path basename)}} | each { $'($in.dir)\($in.basename)-completions.nu' } | where {$in | path exists} | each { $'source ($in)' } |
## => Handpicked
const custom_completions = ['cargo', 'git', 'nano', 'rustup', 'winget']
let completions1 = $custom_completions | each { $'source custom-completions\($in)\($in)-completions.nu' }
## generated from fish - skip specialized 'git', 'nano' that have custom
## not working 'mysql',
const autogenerated = ['7z','7zr','dotnet','ffmpeg','ffplay','ffprobe','flac','fzf','gitk','hugo','jq','julia','lua','make','mkvextract','pandoc','patch','pg_dump','pg_dumpall','pg_restore','psql','pyenv','python','python2','python3','rustc','sass','vim','wireshark']
let completions2 = $autogenerated | each { $'source custom-completions\auto-generate\completions\($in).nu' }
[...$completions1 ...$completions2] | save -f $out