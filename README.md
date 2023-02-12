# Local Tunnel Installer (Ngrok Alternative)

Roll your own ngrok using your own VPS!
Simple installer using Capistrano.
Local tunneling done via SSH Reverse Tunneling.

## Prerequisites

- This script assumes you are using Debian-based server.
  Tested using Ubuntu 22.04.
- You MUST use DigitalOcean DNS. If you want to use
  another DNS, you can edit `lib/capistrano/tasks/letsencrypt.rake`
- The VPS/Server hosting itself does not matter. It does not
  necessarily hosted on DigitalOcean
- Server setup using Capistrano. You can use rbenv/rvm.
  In this document, we will be using rvm.

## Preparation

Install all dependency on your local

    rvm install 3.1.2
    git clone https://github.com/mufid-experiments/ngrok-alternative
    cd ngrok-alternative
    bundle

Copy example configuration file and edit it accordingly.

    cp config/deploy/{production.example.rb,production.rb}

## Installation

Simply run the script:

    bin/cap production localtunnel:install

Don't worry, the script is idempotent.

To open tunnel from your local, run:

    bin/cap production localtunnel:instruction
