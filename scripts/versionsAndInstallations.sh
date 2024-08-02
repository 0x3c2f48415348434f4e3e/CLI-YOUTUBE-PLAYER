#!/usr/bin/bash

#Using WSL2 (Ububtu distro)

#conversion of string to integer (removing the period)
PYTHON_INSTALLED="0"
VERSION_TO_INT(){
	echo "$1" | awk -F. '{ printf("%d%02d%02d\n", $1, $2, $3); }'
}

REQUIRED_PYTHON_VERSION="3.10.12"
INSTALLED_PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
#do same for pip
REQUIRED_PIP_VERSION="22.0.2"
INSTALLED_PIP_VERSION=$(pip3 --version 2>&1 | awk '{print $2}')
#do same for ffmpeg
REQUIRED_FFMPEG_VERSION="4.4.2-0"
INSTALLED_FFMPEG_VERSION=`ffmpeg -version | sed -n "s/ffmpeg version \([-0-9.]*\).*/\1/p;"`

#find way to get version of youtub-dl

REQUIRED_PYTHON_VERSION_INT=$(VERSION_TO_INT "$REQUIRED_PYTHON_VERSION")
INSTALLED_PYTHON_VERSION_INT=$(VERSION_TO_INT "$INSTALLED_PYTHON_VERSION")

#do same for pip
REQUIRED_PIP_VERSION_INT=$(VERSION_TO_INT "$REQUIRED_PIP_VERSION")
INSTALLED_PIP_VERSION_INT=$(VERSION_TO_INT "$INSTALLED_PIP_VERSION")

#do same for ffmpeg
REQUIRED_FFMPEG_VERSION_INT=$(VERSION_TO_INT "$REQUIRED_FFMPEG_VERSION")
INSTALLED_FFMPEG_VERSION_INT=$(VERSION_TO_INT "$INSTALLED_FFMPEG_VERSION")

if [[ INSTALLED_PYTHON_VERSION_INT -ge REQUIRED_PYTHON_VERSION_INT ]]
then
	echo "Python version is $INSTALLED_PYTHON_VERSION and meets the requirement of >= $REQUIRED_PYTHON_VERSION"
elif [[ INSTALLED_PYTHON_VERSION_INT -lt REQUIRED_PYTHON_VERSION_INT ]]
	# remove the curren python installation to ensure no future bugs, then install latest version. User will do this themselves
then
	echo "Python version is $INSTALLED_PYTHON_VERSION and does not meet the requirement of >= $REQUIRED_PYTHON_VERSION. Please remove your current version and install $REQUIRED_PYTHON_VERSION or higher."
    	exit 1
else
	#obviously python is not installed
	#update package manager
	
	#set PYTHON_INSTALLED
	PYTHON_INSTALLED=1

	sudo apt-get update
	sudo apt upgrade
	sudo apt install software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa
	Sudo apt update
	sudo apt install python3
	#verify python installation
	python3 --version
fi

#Same thing here for pip
if [[ INSTALLED_PIP_VERSION_INT -ge REQUIRED_PIP_VERSION_INT ]]
then
	echo "Pip version is $INSTALLED_PIP_VERSION and meets the requirement of >= $REQUIRED_PIP_VERSION"
elif [[ INSTALLED_PIP_VERSION_INT -lt REQUIRED_PIP_VERSION_INT ]]
then
	#remove the current pip3 version to ensure no future bugs, then install the latest version. User do this themseelved
	echo "Pip version is $INSTALLED_PIP_VERSION and does not meet the requirement of >= $REQUIRED_PIP_VERSION. Please remove your current version and install $REQUIRED_PIP_VERSION or higher."
	exit 1
else
	#obviously pip is not installed
	#update pakage mana
	#check if PYTHON_INSTALLED is truthy
	if [[ PYTHON_INSTALLED -eq 1 ]]
	then
		#if python3 was installed with the above command, the installation of pip3 should be as below
		#do not sudo update,upgrade etc
		#https://bootstrap.pypa.io/
		curl -sS https://bootstrap.pypa.io/pip/3.7/get-pip.py | python3
		#verify installation
		pip3 --version
	else
		sudo apt-get update
		sudo apt upgrade
		sudo apt install python3-pip
		#verify pip installation
		pip3 --version
	fi

fi

#by default python modules are installed at /home/{username}/.local/bin
#replace {username} with user actual name
#__PATH__="/home/$USER/.local/bin"
__PATH__="/usr/local/lib/python3.10/dist-packages"
#check that youtube-dl exist in that path
DOES_YOUTUBEDL_EXIST=`ls "$__PATH__" 2>&1 | awk '{print $1}' | grep youtube_dl`
if [[ DOES_YOUTUBE_EXIST=="youtube_dl youtube_dl-2021.12.17.dist-info" ]]
then
	#no need to reinstall
	#makre sure version is the same or higher than the one used in this
	echo "youtube-dl package already installed"
else
	#pip install youtube-dl
	sudo pip install --upgrade --force-reinstall "git+https://github.com/ytdl-org/youtube-dl.git"
fi
#add youtube-dl to path
#export PATH="$__PATH__:$PATH"
#source ~/.bashrc
#according to the youtube-dl docs, ffmeg is also required
if [[ INSTALLED_FFMPEG_VERSION_INT -ge REQUIRED_FFMPEG_VERSION_INT ]]
then
	echo "Ffmpeg version is $INSTALLED_FFMPEG_VERSION and meets the requirement of >= $REQUIRED_FFMPEG_VERSION"
elif [[ REQUIRED_FFMPEG_VERSION_INT -lt INSTALLED_FFMPEG_VERSION_INT ]]
then
	echo "Ffmpeg version is $INSTALLED_FFMPEG_VERSION and does not meet the requirement of >= $REQUIRED_FFPEG_VERSION. Please remove your current version and install $REQUIRED_FFPEG_VERSION or higher."
	exit 1
else
	sudo apt  install ffmpeg
fi
#hopefully that should work. If does not work, create an issue

chmod +x fetchYoutube.py

#add outputfile

outputFile="../downloads/$1.mp4"
#run python script with provided youtube URL by user
python3 ./fetchYoutube.py $1 $outputFile
