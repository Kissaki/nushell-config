# Download highest quality Opus audio as/into .opus file
def "dl opus" [url: string] {
	yt-dlp --extract-audio --audio-quality 0 --audio-format opus $"($url)"
}

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
