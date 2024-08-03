# Requirements
Python - Python 3.10.12 (Installed via apt package manager)

pip3 - pip 22.0.2 from /usr/lib/python3/dist-packages/pip (python 3.10) (installed via apt package manager, python3-pip, sudo apt install python3-pip)

youtube-dl - youtube_dl-2021.12.17-py2.py3-none-any.whl (installed via pip3, pip install youtube-dl)

FFmpeg - version 7:4.4.2-0ubuntu0.22.04.1 (install via apt package manager, sudo apt  install ffmpeg)

# Weird File format
Reason why you see the wierd file structure in the download is due to how windows/linux operate with file conventions. So a file can not have characetrs like /or \
# 
Have a method of determining the firl format for example is it an MP3 orr MP4, then append to ensure correct data or whatever. Implting youtube-dl for this task

# 
If donwloaded content is a youtube vido (so MP4 format, most likely), then display it using ASCII. If it is an audio (Most likly MP3), then diaplsy a visual mode represeting the actual wave of the content, if that makes sense
