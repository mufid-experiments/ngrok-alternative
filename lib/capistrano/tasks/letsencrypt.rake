namespace :letsencrypt do
  task :install do
    invoke 'apt:certbot'
    invoke 'letsencrypt:setup'
  end
  task :setup do
    on roles(:app), in: :parallel do |host|
      files = capture(:sudo, :find, '/etc/letsencrypt')

      if files.include?(fetch(:target_domain))
        warn '[letencrypt] Already installed. Skipping.'
        next
      end

      certbot_creds = "dns_digitalocean_token = #{fetch(:digitalocean_api_token)}"
      upload! StringIO.new(certbot_creds), 'certbot-creds.ini'

      execute :chmod, 600, '~/certbot-creds.ini'
      info "Running certbot"
      execute :sudo, :certbot, :certonly,
                     '--non-interactive',
                     '--agree-tos',
                     '-m', fetch(:certbot_email),
                     '--dns-digitalocean',
                     '--dns-digitalocean-credentials', '~/certbot-creds.ini',
                     '-d', fetch(:target_subdomain)
    end
  end
end
