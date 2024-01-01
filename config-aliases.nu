#alias edit = `C:\Program Files\Notepad++\Notepad++.exe`
#alias edit = `C:\Program Files\Vim\vim90\vim.exe`
alias vim = `C:\Program Files\Vim\vim90\vim.exe`
#alias micro = `C:\bin\micro.exe` # installed - workes through PATH anyway

alias up = winget upgrade
def ups [...name: string] {
  for $n in $name {
    winget upgrade $n
  }
}

alias dl = yt-dlp
alias dlup = yt-dlp --update
alias dlm = yt-dlp -f 251

alias ff = ffmpeg -hide_banner
alias fp = ffprobe -hide_banner
#old-alias ffweb = ff -i $1 -map_chapters -1 -map 0:v -map 0:a -c:v libsvtav1 -pix_fmt yuv420p10le -c:a libopus $2

# External forwards
#def vim [...args] { ^`C:\Program Files\Vim\vim90\vim.exe` $args }
