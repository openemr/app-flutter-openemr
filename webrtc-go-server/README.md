# flutter-webrtc-server
A simple WebRTC Signaling server for flutter-webrtc and html5.

## Features
- Support Windows/Linux/macOS

## Usage

### Run binary

- Clone the repository
- Run 

    ```bash
    cd flutter-webrtc-server
    # for macOS
    ./bin/server-darwin-amd64
    # for Linux
    ./bin/server-linux-amd64
    # for Windows
    ./bin/server-windows-i386.exe
    ```

### Compile from Source
- Clone the repository, run `make`.  
- Run `./bin/server-{platform}-{arch}` and open https://0.0.0.0:8086 to use html5 demo.

## Note
This is still a beta version so it may have some security issues so please do not use it for production application
