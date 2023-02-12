namespace :apt do
  task :certbot do
    on roles(:app) do
      info "Installing certbot"
      execute :sudo, :apt, :install, '-y', 'python3-certbot-dns-digitalocean'
      execute :certbot, :plugins
    end
  end
end
