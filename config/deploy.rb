# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "localtunnel"
set :repo_url, "git@example.com:me/my_repo.git"

set :pty, true
set :default_env, { :path => '$PATH:$HOME/bin:$HOME/.local/bin' }
