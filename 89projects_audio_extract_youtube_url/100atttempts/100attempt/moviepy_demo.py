from moviepy.editor import VideoFileClip

# def download_video(url, output_path):
#     try:
#         video = VideoFileClip(url)
#         video.write_videofile(output_path)
#         print(f"Video downloaded successfully: {output_path}")
#     except Exception as e:
#         print(f"Error downloading video: {str(e)}")

def download_video(url, output_path):
    try:
        video = VideoFileClip(url, target_resolution=(640, 480), format='mp4')
        video.write_videofile(output_path)
        print(f"Video downloaded successfully: {output_path}")
    except Exception as e:
        print(f"Error downloading video: {str(e)}")


# Example usage
video_url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
output_file = "downloaded_video.mp4"

download_video(video_url, output_file)
