alias te = table -e
# Prevent Windows from opening Wordpad when accidentally writing `write` instead of `save`
alias write = print 'Did you mean to write `save`?'

alias ll = ls -al
# latest GitHub release - repo form: account/repo
def "gh latest" [repo: string] { http head $'https://github.com/($repo)/releases/latest/' --redirect-mode manual | where name == location | get value.0 | path split | last }
def "ss status" [] { sudo sc query SunshineService }
def "ss start" [] { sudo sc start SunshineService }
def "ss stop" [] { sudo sc stop SunshineService }
alias ss = ss status

def "gits most-changed-files" [] { git log --format=format: --name-only --since="1 year ago" | lines | str trim | where (is-not-empty) | uniq --count | sort-by count --reverse | take 20 }
def "gits who" [] { git shortlog -sn --no-merges }
def "gits who6m" [] { git shortlog -sn --no-merges --since="6 months ago" }
def "gits fixes" [] { git log -i -E --grep="fix|bug|broken" --name-only --format='' | lines | str trim | where (is-not-empty) | uniq --count | sort-by count --reverse | take 20 }
def "gits aliveness" [] { git log --format='%ad' --date=format:'%Y-%m' | lines | str trim | where (is-not-empty) | uniq --count }
def "gits firefighting" [] { git log --oneline --since="1 year ago" | find --ignore-case --regex 'revert|hotfix|emergency|rollback' }

# Shorts
## Native
def e [...args] { ^($env.EDITOR) ...$args }
## Scripts and Plugins
alias c = task spawn { code . }
alias p = pueue
alias t = task
# ISSUE: Command 'task' not found
def s [...args] { task spawn { $args } }
## Apps
alias gi = `gitui`
alias nb = dotnet build --nologo
alias np = dotnet publish --nologo
def "np win" [...args] { np --os win ...$args }
def "np lin" [...args] { np --os linux ...$args }
def "np linux" [...args] { np --os linux ...$args }
alias f = filemeta

# editors (text)
#alias edit = `C:\Program Files\Notepad++\Notepad++.exe`
#alias edit = `C:\Program Files\Vim\vim90\vim.exe`
alias vim = `C:\Program Files\Vim\vim90\vim.exe`
#def vim [...args] { ^`C:\Program Files\Vim\vim90\vim.exe` $args }

#alias code = $'($env.USERPROFILE)\AppData\Local\Programs\Microsoft VS Code\Code.exe'
#def code [...args] { ^$'($env.USERPROFILE)\AppData\Local\Programs\Microsoft VS Code\Code.exe` ($args | str join " ") }

# winget
alias up = winget upgrade
def ups [...name: string] {
  if ($name | is-empty) { winget upgrade; return }
  for $n in $name {
    winget upgrade $n
  }
}

def "ups dotnet-tools" [] {
	dotnet tool update --global --all
}

# yt-dlp
alias dl = yt-dlp
alias dlup = yt-dlp --update
alias dlm = yt-dlp -f 251
# Download highest quality Opus audio as/into .opus file
def "dl opus" [...params: string, url: string] {
	dl --extract-audio --audio-quality 0 --audio-format opus $"($url)"
}
# Download highest quality Opus audio as/into .opus file with cookies from Firefox
def "dl opus firefox" [url: string] {
	dl --extract-audio --audio-quality 0 --audio-format opus --cookies-from-browser firefox $url
}
# Download [YouTube] video with SponsorBlock chapters
def "dl yt" [...args: string] {
	dl --sponsorblock-mark all -- ...$args
}
# Download video with cookies from Firefox - Usage: `dl firefox --download-sections "*1:8-1:12" https://www.youtube.com/watch?v=CvJ582A_G1U
def "dl firefox" [...args: string] {
	dl --cookies-from-browser firefox -- ...$args
}
# Download [YouTube] video with SponsorBlock chapters with cookies from Firefox
def "dl yt firefox" [...args: string] {
	dl --sponsorblock-mark all --cookies-from-browser firefox -- ...$args
}
# Download video with cookies from Firefox and save it to a titled filename
def "dl firefox titled" [title: string, url: string] {
	dl --cookies-from-browser firefox --output $"($title) %(title)s [%(id)s].%(ext)s" $"($url)"
}
def "dl timed" [begin: string, end: string, url: string] {
	dl --download-sections $"*($begin)-($end)" $url
}
def "dl section" [sectionname: string, url: string] {
	dl --download-sections $"($sectionname)*" $url
}

# ffmpeg
alias ff = ffmpeg -hide_banner
alias fp = ffprobe -hide_banner
alias ffp = ffprobe -hide_banner
# 10-bit x265 opus mkv
def "ff 10" [filepath: path] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_10-bit-x265"} | update extension "mkv" | path join)
    ff -i $filepath -c:a libopus -c:v libx265 -pix_fmt yuv420p10le $target
}
# 10-bit av1 opus mkv
def "ff 10av1" [filepath: path] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_10-bit-av1"} | update extension "mkv" | path join)
    ff -i $filepath -c:a libopus -c:v libsvtav1 -pix_fmt yuv420p10le $target
}

# 10-bit av1 opus webm
def "ff webm" [filepath: path] {
    let target = ($filepath | path parse | update extension "webm" | path join)
    ff -i $filepath -c:a libopus -c:v libsvtav1 -pix_fmt yuv420p10le $target
}
# 10-bit av1 opus webm, first streams, no chapters
def "ff webm0" [filepath: path] {
    let target = ($filepath | path parse | update extension "webm" | path join)
    ff -i $filepath -map_chapters -1 -map 0:v -map 0:a -c:a libopus -c:v libsvtav1 -pix_fmt yuv420p10le $target
}
# 8-bit x264 mp4
def "ff mp4" [filepath: path] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_x264"} | update extension "mp4" | path join)
    ff -i $filepath -c:a aac -c:v libx264 -pix_fmt yuv420p $target
}
# Extract audio stream $anr and normalize audio with loudnorm filter, $ext is audio file type (like 'ac3' or 'opus')
def "ff loudnorm" [filepath: path, anr: int, ext: string] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_loudnorm"} | update extension $ext | path join)
    ff -i $filepath -map $'0:a:($anr)' -filter:a loudnorm $target
}
def "ff loudnorm opus" [filepath: path, anr: int] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_loudnorm"} | update extension 'opus' | path join)
    ff -i $filepath -map $'0:a:($anr)' -filter:a loudnorm -ac 2 $target
}

def "nu conf diff" [] {
  let defaults = nu -n -c "$env.config = {}; $env.config | reject color_config keybindings menus | to nuon" | from nuon | transpose key default
  let current = $env.config | reject color_config keybindings menus | transpose key current
  $current | merge $defaults | where $it.current != $it.default
}

def "nuplugin upgrade" [nuVersion: string, myVersion: int = 0] {
  let vBefore = open Cargo.toml | get dependencies.nu-plugin

  let major = date now | format date "%y"
  let parts = $nuVersion | split row '.'
  let parts = if $parts.0 == '0' { $parts | skip 1 } else { $parts }
  let minor = $parts | str join
  let vAfter = $'($major).($minor).($myVersion)'

  print "Attempting to upgrade ($vBefore) -> ($nuVersion) [($vAfter)]…"
  cargo update --verbose;
  git add Cargo.lock
  git commit -m "misc: Upgrade dependencies" ;
  open Cargo.toml | update dependencies.nu-plugin $nuVersion | update dependencies.nu-protocol.version $nuVersion | update package.version 26.1121.0 | save Cargo.toml --force;
  cargo update --verbose;
  git add Cargo.lock Cargo.toml
  git commit -m $"misc: Upgrade Nushell ($vBefore) -> ($nuVersion)";
  cargo check
}

# https://en.wikipedia.org/wiki/Byte_order_mark#Byte-order_marks_by_encoding
const boms = [
    { hex: "EFBBBF", label: "UTF-8" },
    { hex: "FEFF", label: "UTF-16 (BE)" },
    { hex: "FFFE", label: "UTF-16 (LE)" },
    { hex: "0000FEFF", label: "UTF-32 (BE)" },
    { hex: "FFFE0000", label: "UTF-32 (BE)" },
    { hex: "2B2F76", label: "UTF-7" },
    { hex: "F7644C", label: "UTF-1" },
    { hex: "DD736673", label: "UTF-EBCDIC" },
    { hex: "0EFEFF", label: "SCSU" },
    { hex: "FBEE28", label: "BOCU-1" },
    { hex: "84319533", label: "GB18030" },
]
let boms_lookup = $boms | sort-by { |it| $it.hex | str length } --reverse
# Detect BOM (byte order mark), return BOM label
@example "Determine BOM of a text file" { open test.txt | into binary | bom }
@example "Binary data BOM result" { 'EFBBBF33' | decode hex | bom } --result 'UTF-8'
@category strings
def "bom" []: binary -> string {
    let hex_signature = ($in | into binary | take 4 | encode hex)
    $boms_lookup | where {|it| $hex_signature | str starts-with $it.hex } | first | default { label: 'None/Unknown' } | get label
}
