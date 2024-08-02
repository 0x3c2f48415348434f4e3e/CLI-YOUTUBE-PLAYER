#!/usr/bin/python3

#taken from docs https://github.com/ytdl-org/youtube-dl/tree/master

from __future__ import unicode_literals
import youtube_dl
import sys

class MyLogger(object):
	def debug(self, msg):
		print(msg)
	def warning(self, msg):
		print(msg)
	def error(self, msg):
		print(msg)
#ensure the number of user arguments is no more than 2 -> that is the name of the script itself and the URL passed from the shell script
length = len(sys.argv)
if (length < 3):
	print("To few arguments passed in")
	sys.exit(-1)

if (length > 3):
	print("To many arguments passed in")
	sys.exit(-1)

requestURL = sys.argv[1] #youtube URL
outputFile = sys.argv[2]
def my_hook(d):
	#check for error
	if d['status'] == 'error':
		print("Error...")
		sys.exit(-1)
	
	#check for downloading
	if d['status'] == 'downloading':
		#get file info
		print("Downloading:",d['filename'])
		print("Writing to:",d['tmpfilename'])
		print("Bytes on disk:",d['downloaded_bytes'])
		#print("Total bytes:",d['total_bytes_estimate'])
		#print("Total bytes estimate:",d['total_bytes_estimate'])
		print("Elapsed:",d['elapsed'])
		print("Eta:",d['eta'])
		print("Speed in bytes/seconds:",d['speed'])
		#print("Fragment_index:",d['fragment_index'])
		#print("Fragment_count:",d['fragment_count'])

	#check for finished
	if d['status'] == 'finished':
		print("Done downloading, now converting ...")


def downloadVideo(URL,OUTPUTFile:str):
	ydl_opts = {
		'format':'best',
		'logger':MyLogger(),
		'progress_hooks':[my_hook],
		'outtmpl':OUTPUTFile
	}
	with youtube_dl.YoutubeDL(ydl_opts) as ydl:
		ydl.download([URL])

if __name__ == "__main__":
	downloadVideo(requestURL,outputFile)
