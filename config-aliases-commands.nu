alias te = table -e

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

# dotnet
# List Directory.Packages.props version declarations that are in no csproj
def "dotnet unused-dirpackprops" [] {
  let defs = open Directory.Packages.props | from xml | get content | where tag == ItemGroup | get content.attributes.Include | flatten | sort --ignore-case --natural
  let refs = ls **/*.csproj | get name | each { open | from xml | get content | select content | flatten | flatten | where tag == PackageReference | get attributes.Include } | flatten | uniq | sort --ignore-case --natural
  $defs | difference $refs
}

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
def "dl opus" [url: string, ...params: string] {
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

# Get the last $count command history
def "history last" [count?: int = 7, only?: bool] {
  if $only != null {
    open $nu.history-path | get history | where ($it.exit_status == 0) == $only | last $count
  } else {
    open $nu.history-path | get history | last $count
  }
  #open $nu.history-path | query db 'select * from history where exit_status != 0'
}
def "history count" [] {
  open $nu.history-path | query db 'select count(*) from history'
}
# Remove failed commands from command history (exit code != 0) - requires $nu.history_path to be sqlite (modern command history store)
def "history cleanup" [] {
  open $nu.history-path | query db 'delete from history where exit_status != 0'
}

def "tablestat" [] {
  let $table = $in
  $table | columns | each {|col| { column: $col, count: ($table | get $col | where { |v| not ($v | is-empty) } | length) } }
}

# Graphene-based `str substring`
# `str substring` goes over bytes instead of graphenes => split chars, range, join chars
def "substr" [r: range] {
  split chars | slice $r | str join
}

# \ pwsh wraps \
# Wraps pwsh, separating stdout and stderr into a complete result
# PowerShell has its own warning stream for output, in addition to stdout and stderr. A simple `3>&2` is not supported. So we combine the pwsh object streams and then, for pwsh call output, stream the warning records into stderr instead of stdout.
# Returns a `complete` record
# Example: pws ls | 
def --wrapped pws [
  --noprofile
  ...args: string
] {
  let command = ($args | str join " ")
  
  let wrapper = "
    [Console]::OutputEncoding = [Text.Encoding]::UTF8
    $ErrorActionPreference = 'Continue'
    & { " + $"($command)" + " } 3>&1 | ForEach-Object {
      if ($_ -is [System.Management.Automation.WarningRecord]) {
        [Console]::Error.WriteLine($_.Message)
      } else {
        $_
      }
    }
    exit $LASTEXITCODE
  "
    
  let pwsh_args = ["-Command", $wrapper]
  let pwsh_args = if $noprofile { $pwsh_args | prepend "-NoProfile" } else { $pwsh_args }

  # complete to return structured data with stdout and stderr
  ^pwsh ...$pwsh_args | complete
}

# Execute pwsh with result objects expected, converted and interpreted as json
# Returns: {data,stderr,exit_code}
# Example: pwso `Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Windows Defender/Operational'; Id=1123} -MaxEvents 3` | get data.Message
def --wrapped pwso [...args: string] {
  let command = ($args | str join " ") + " | ConvertTo-Json -Compress"
  pws $command | insert data { $in.stdout | from json } | reject stdout
}

# Lists MS Defender operational events
def "win blocked" [
  --parse-datetime # Parse 'Detection time' into datetime
] {
  # Alternative Filter: `Id=@(1123, 1127)`; 1123: controlled folder access folder access denied, 1127 controlled folder/memory access memory access denied
  let data = pwso `Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Windows Defender/Operational'; Level=@(1, 2, 3)} -MaxEvents 3 | Select-Object TimeCreated, Id, Message` | get data.Message | each { lines | where $it =~ '(Detection time|Process Name|Path)' | str trim | each { parse '{Key}: {Value}' } | flatten | transpose --header-row } | flatten
  if $parse_datetime { $data | update 'Detection time' {|x| $x | get 'Detection time' | into datetime } } else { $data }
}

# Allow application to modify files (in controlled folder access context)
# Example: After verifying last item should be allowed: win unblock (win blocked | first | get 'Process Name')
def "win unblock" [path: path] {
  pws $'Add-MpPreference -ControlledFolderAccessAllowedApplications "($path)"'
}

# Execute command through powershell with putput encoding set to UTF8
# Can work around windows CLI util output -> Nushell -> Windows Terminal yielding wrong encoding/wrong interpreted encoding yielding render artifacts
def "pwsh-utf8" [cmd] {
  ^pwsh --command $"[Console]::OutputEncoding = [Text.Encoding]::UTF8; ($cmd)"
}

# / pwsh wraps /

# \ Windows \

# Prevent Windows from opening Wordpad when accidentally writing `write` instead of `save`
alias write = print 'Did you mean to write `save`?'

# List start menu uninstall lnk files
# Example: Remove all 'uninstall' start menu shortcuts: win startuninst | get path | each { rm $in }
def "win startuninst" [] {
  glob 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/**/*Uninstall*.lnk' | wrap path | insert filename { $in.path | path basename } | insert foldername { $in.path | path dirname | path basename }
}

# List disks with their DevicePath
def "win disks" [] {
  # nu code: If std-rfc/str dedent or unindent land, we can indent the multi line string in code and then dedent it when passing it to pwsh
  # Note: Can not indent it; leads to pwsh errors (not forwarded, just exit code)
  pwso '
Add-Type -TypeDefinition @"
  using System;
  using System.Runtime.InteropServices;
  using System.Text;

  public class DosDeviceResolver {
      [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
      public static extern uint QueryDosDevice(string lpDeviceName, StringBuilder lpTargetPath, int ucchMax);
  }
"@

[System.IO.DriveInfo]::GetDrives() | ForEach-Object {
  $driveLetter = $_.Name.TrimEnd('\')
  $sb = New-Object System.Text.StringBuilder 32768
  $ret = [DosDeviceResolver]::QueryDosDevice($driveLetter, $sb, $sb.Capacity)
  if ($ret -ne 0) {
    [PSCustomObject]@{
      Drive       = $_.Name
      VolumeLabel = if ($_.IsReady) { $_.VolumeLabel } else { "[Not Ready]" }
      DevicePath  = $sb.ToString()
    }
  }
}'
}

def "win ad groups" [] {
  # is passing through pwsh still a necessary workaround for utf8 output?
  pwsh-utf8 "^whoami /groups" | lines | skip 5 | each {
    {
      GroupName: ($in | substr 0..56 | str trim --right),
      Type: ($in | substr 57..73),
      SID: ($in | substr 74..119),
      Attributes: ($in | substr 120..),
    }
  }
}

# / Windows /
