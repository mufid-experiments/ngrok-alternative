namespace :localtunnel do
  task :install do
    invoke 'infra:load_ip'
    invoke 'localtunnel:apt_update'
    invoke 'localtunnel:apt_nginx'
    invoke 'localtunnel:letsencrypt'
  end

  task :apt_update do
    on roles(:app), in: :parallel do |host|
      execute :sudo, :apt, :update
    end
  end

  task :apt_nginx do
    on roles(:app), in: :parallel do |host|
      execute :sudo, :apt, :install, '-y', :nginx
    end
  end

  task :letsencrypt do
    on roles(:app), in: :parallel do |host|
      execute :sudo, :apt, :install, '-y', 'python3-certbot-dns-digitalocean'
      execute :certbot, :plugins
      execute :find, '/etc/letsencrypt'

      letsencrypt_config = "dns_digitalocean_token = #{fetch(:digitalocean_api_token)}"

      within("~") do
        upload! StringIO.new(letsencrypt_config), "certbot-creds.ini"
      end

      execute :chmod, 600, '~/certbot-creds.ini'
      execute :sudo, :certbot, :certonly,
                     '--dns-digitalocean',
                     '--dns-digitalocean-credentials', '~/certbot-creds.ini',
                     '-d', fetch(:target_subdomain)
    end
  end
end
