# Local Tunnel Installer (Ngrok Alternative)

Roll your own ngrok using your own VPS!
Simple installer using Capistrano. This
scripts assume you are using Debian-based server.

## Preparation

Install all dependency on your local

    rvm install
    bundle

Copy example configuration file and edit it accordingly.

    cp config/deploy/{production.example.rb,production.rb}

## Installation

Simply run the script:

    bin/cap production localtunnel:install

Don't worry, the script is idempotent.

To open tunnel from your local, run:

    bin/cap production localtunnel:instruction
