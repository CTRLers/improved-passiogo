import subprocess
import time
import os

# Function to start the Rails server
def start_rails_server():
    print("Starting Rails server...")
    rails_process = subprocess.Popen(["rails", "server"], stdout=None, stderr=None)
    return rails_process

# Function to start FastAPI Unicorn server
def start_unicorn_server():
    print("Starting FastAPI Unicorn server...")

    # Navigate to the FastAPI directory
    fastapi_dir = os.path.abspath("passiogo")
    os.chdir(fastapi_dir)

    # Start Unicorn server for FastAPI
    unicorn_process = subprocess.Popen(["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"], stdout=None, stderr=None)
    return unicorn_process

if __name__ == "__main__":
    rails_process = start_rails_server()

    # Wait a bit to ensure the Rails server starts before launching Unicorn
    time.sleep(5)

    unicorn_process = start_unicorn_server()

    # Keep the script running to prevent child processes from being killed
    try:
        rails_process.wait()
        unicorn_process.wait()
    except KeyboardInterrupt:
        print("\nShutting down servers...")
        rails_process.terminate()
        unicorn_process.terminate()
