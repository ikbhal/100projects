import youtube_dl

def download_video(url, output_path):
    try:
        ydl_opts = {
            'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',
            'outtmpl': output_path
        }
        with youtube_dl.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
        print(f"Video downloaded successfully: {output_path}")
    except Exception as e:
        print(f"Error downloading video: {str(e)}")

# Example usage
# video_url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
# hindi barakhaid video
video_url = "https://www.youtube.com/watch?v=qTlyFt6SYcw"
output_file = "downloaded_video.mp4"

download_video(video_url, output_file)
