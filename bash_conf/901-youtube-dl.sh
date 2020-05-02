
[[ -f "/usr/local/bin/youtube-dl" ]] || { return ; }


ct_youtubePlayListDownload() {
  youtube-dl -f mp4 --yes-playlist -i "$1" "$2" "$3" "$4" "$5"
}

ct_youtubePlayListDownloadWithSubtitles() {
  local YOUTUBE_PLAYLIST_URL="$1"
  youtube-dl -f mp4 --yes-playlist -x --sub-lang pt --write-sub --sub-format vtt --convert-subtitles srt --write-auto-sub  -i $YOUTUBE_PLAYLIST_URL
}


ct_youtubeSubtitlesAutoGenerateDownloadAll() {
    local YOUTUBE_URL="$1"
    youtube-dl --all-subs --skip-download --write-auto-sub $YOUTUBE_URL
}

ct_youtubeSubtitlesAutoGenerateDownload() {
    local YOUTUBE_URL="$1"
    youtube-dl -x --sub-lang pt --write-sub --sub-format vtt --convert-subtitles srt --write-auto-sub --skip-download $YOUTUBE_URL
}