#!/bin/bash
set -e

# Start the FastAPI (Passiogo) application using Uvicorn on port 8080 in the background.
cd /rails/passiogo
uvicorn main:app --host 0.0.0.0 --port 8080 &

# Return to the Rails app directory and start the Rails server in the foreground.
cd /rails
exec ./bin/rails server -b 0.0.0.0 -p 80
