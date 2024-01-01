# Extends env file (`$nu.env-path` `C:\Users\USER\AppData\Roaming\nushell\env.nu`)
# Sourced there through `source '~\nushell\env.nu'`

$env.NU_LIB_DIRS = ($env.NU_LIB_DIRS | append
    '~/nushell/nu_scripts'
    )

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

#zoxide init nushell | save -f ~/.zoxide.nu

# custom completion sourcing - from nu_scripts
# broken 'winget'
['cargo', 'git', 'nano', 'rustup', 'vscode']
  | each {|n| $'source custom-completions\($n)\($n)-completions.nu' }
  | save -f ~/.cache/source-completions.nu
# generated from fish - skip specialized 'git', 'nano'
# not working 'mysql',
['7z','7zr','dotnet','ffmpeg','ffplay','ffprobe','flac','fzf','gitk','hugo','jq','julia','lua','make','mkvextract','pandoc','patch','pg_dump','pg_dumpall','pg_restore','psql','pyenv','python','python2','python3','rustc','sass','vim','wireshark']
  | each {|n| $'source custom-completions\auto-generate\completions\($n).nu' }
  | save -f ~/.cache/source-completions_fish-generated.nu
