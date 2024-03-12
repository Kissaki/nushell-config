# Download highest quality Opus audio as/into .opus file
def "dl opus" [url: string] {
	yt-dlp --extract-audio --audio-quality 0 --audio-format opus $"($url)"
}
