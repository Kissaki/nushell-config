alias ll = ls -al

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

# yt-dlp
alias dl = yt-dlp
alias dlup = yt-dlp --update
alias dlm = yt-dlp -f 251
# Download highest quality Opus audio as/into .opus file
def "dl opus" [url: string] {
	yt-dlp --extract-audio --audio-quality 0 --audio-format opus $"($url)"
}

# ffmpeg
alias ff = ffmpeg -hide_banner
alias fp = ffprobe -hide_banner
#old-alias ffweb = ff -i $1 -map_chapters -1 -map 0:v -map 0:a -c:v libsvtav1 -pix_fmt yuv420p10le -c:a libopus $2
def "ff 10" [filepath: path] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_10-bit-x265"} | update extension "mkv" | path join)
    ff -i $filepath -c:a libopus -c:v libx265 -pix_fmt yuv420p10le $target
}
def "ff webm" [filepath: path] {
    let target = ($filepath | path parse | update extension "webm" | path join)
    ff -i $filepath -c:a libopus -c:v libsvtav1 -pix_fmt yuv420p10le $target
}
def "ff web" [filepath: path] {
    ff webm $filepath
}
def "ff mp4" [filepath: path] {
    let target = ($filepath | path parse | update stem {|x| $"($x.stem)_x264"} | update extension "mp4" | path join)
    ff -i $filepath -c:a aac -c:v libx264 -pix_fmt yuv420p $target
}
