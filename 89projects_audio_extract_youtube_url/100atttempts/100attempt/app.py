import os
from flask import Flask, request, send_file
from moviepy.editor import VideoFileClip

app = Flask(__name__)

@app.route('/extract_audio', methods=['POST'])
def extract_audio():
    # Retrieve the YouTube video URL, start time, and end time from the request
    video_url = request.form.get('video_url')
    start_time = request.form.get('start_time')
    end_time = request.form.get('end_time')

    # Set the output audio file path
    output_file = 'audio.mp3'

    try:
        # Download the video using moviepy
        video = VideoFileClip(video_url)

        # Extract the audio from the specified start and end time
        audio = video.audio.subclip(start_time, end_time)

        # Write the audio to a file
        audio.write_audiofile(output_file)

        # Return the extracted audio file as a response
        return send_file(output_file, mimetype='audio/mpeg')
    except Exception as e:
        return str(e)
    finally:
        # Remove the temporary audio file
        if os.path.exists(output_file):
            os.remove(output_file)

if __name__ == '__main__':
    app.run()
