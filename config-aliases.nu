# winget
alias up = winget upgrade
def ups [...name: string] {
  for $n in $name {
    winget upgrade $n
  }
}

# yt-dlp
alias dl = yt-dlp
alias dlup = yt-dlp --update
alias dlm = yt-dlp -f 251

# ffmpeg
alias ff = ffmpeg -hide_banner
alias fp = ffprobe -hide_banner
#old-alias ffweb = ff -i $1 -map_chapters -1 -map 0:v -map 0:a -c:v libsvtav1 -pix_fmt yuv420p10le -c:a libopus $2

# Shorts
def e [...args] { ^($env.EDITOR) ...$args }
alias c = task spawn { code . }
alias p = pueue
alias t = task
def s [...args] { task spawn { $args } }
alias gi = `gitui`
alias db = dotnet build --nologo
alias f = filemeta

# editors (text)
#alias edit = `C:\Program Files\Notepad++\Notepad++.exe`
#alias edit = `C:\Program Files\Vim\vim90\vim.exe`
alias vim = `C:\Program Files\Vim\vim90\vim.exe`
#def vim [...args] { ^`C:\Program Files\Vim\vim90\vim.exe` $args }

#alias code = $'($env.USERPROFILE)\AppData\Local\Programs\Microsoft VS Code\Code.exe'
#def code [...args] { ^$'($env.USERPROFILE)\AppData\Local\Programs\Microsoft VS Code\Code.exe` ($args | str join " ") }
