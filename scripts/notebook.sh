#! /bin/zsh

usage()
{
echo "*****************************************************"
cat << EOF
usage: $0 [-r] [-t token]

This script starts a jupyter notebook.

TYPICAL USE:
	$0

	This will start a jupyter notebook, killing existing ones if needed

BASIC OPTIONS:
   -h         Show this message

   -r         A random token will be used

   -k		  Kill existing notebook processes

   -t [token] Use the given token
EOF
echo "*****************************************************"
}


use_token=0
kill_existing=0
while getopts "t:hrk" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         r)
			 use_token=2
             ;;
		 t)
			 use_token=1
			 token="${OPTARG:r}"
             ;;
		 k)
			 kill_existing=$((1-${kill_existing}))
			 ;;
         \?)
			 echo "Invalid option: -$OPTARG" >&2
             usage
             exit
             ;;
     esac
done


echo "Open ssh tunnel:"
PUBLIC_HOST=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
echo "ssh -nNT -L 8888:127.0.0.1:8888 ubuntu@$PUBLIC_HOST"
echo "Connect to:"
echo "http://localhost:8888/"
echo "ssh -nNT -L 8888:127.0.0.1:8888 ubuntu@$PUBLIC_HOST"

if [[ ($kill_existing == 1) ]]; then
	if [ "$(ps ax | grep jupyter-notebook | wc -l)" -gt 0 ]; then
		echo "Killing previous notebook servers"
		killall jupyter-notebook
		echo "Waiting 5 seconds for old processes to shut down"
		sleep 5
	fi
fi

echo "Launching notebook..."
# ip=127.0.0.1 means that it can only be reached from localhost.
if [[ ($use_token == 1) ]]; then
	echo "Starting notebook with the given token"
    jupyter notebook --port=8888 --port-retries=0 --ip=127.0.0.1 --NotebookApp.token="${token}"
elif [[ ($use_token == 2) ]]; then
	echo "Starting notebook with a randomly generated token"
    jupyter notebook --port=8888 --port-retries=0 --ip=127.0.0.1
else
	echo "Starting notebook with no token"
    jupyter notebook --port=8888 --port-retries=0 --ip=127.0.0.1  --NotebookApp.token=''
fi
