echo "Open ssh tunnel:"
HOST=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
echo "ssh -nNT -L 8888:127.0.0.1:8888 ubuntu@$PUBLIC_HOST"
echo "Connet to:"
echo "http://localhost:8888/"
echo "ssh -nNT -L 8888:127.0.0.1:8888 ubuntu@$PUBLIC_HOST"

if [ "$(ps ax | grep jupyter-notebook | wc -l)" -gt 0 ]; then
    echo "Killing previous notebook servers"
    killall jupyter-notebook
    echo "Waiting 5 seconds for old processes to shut down"
    sleep 5
fi

echo "Launching notebook..."
# ip=127.0.0.1 means that it can only be reached from localhost.
jupyter notebook --port=8888 --port-retries=0 --ip=127.0.0.1
