#!/bin/sh
#
## firefox.sh

# Check if something is listening on port 8080
if ! lsof -i :8080 >/dev/null 2>&1; then
    echo "Starting Python server on port 8080..."
    cd ~/app/startpage/
    python3 -m http.server 8080 > /dev/null 2>&1 &
    SERVER_PID=$!
else
    SERVER_PID=""
    echo "Python server already running on port 8080."
fi

# Start Firefox (it will fork in background)
firefox &
FIREFOX_PID=$!
echo "Firefox started with PID: $FIREFOX_PID"

# Wait for the Firefox process to end
wait $FIREFOX_PID

echo "Firefox process has ended. Running post-Firefox commands..."

# If we started the server, kill it
if [ -n "$SERVER_PID" ]; then
    echo "Stopping Python server (PID $SERVER_PID)..."
    kill $SERVER_PID
fi
