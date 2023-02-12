namespace :nginx do
  task :setup do
    invoke 'nginx:upload_config'
    invoke 'nginx:enforce_config'
    invoke 'nginx:verify_and_restart'
  end

  task :upload_config do
    on roles(:app) do
      @cert_fullchain_path = "/etc/letsencrypt/live/#{fetch(:target_domain)}/fullchain.pem"
      @cert_privkey_path = "/etc/letsencrypt/live/#{fetch(:target_domain)}/privkey.pem"
      @target_domain = fetch(:target_domain)
      @target_subdomain = fetch(:target_subdomain)
      template = ERB.new(File.read('template/nginx.erb'))
      result = template.result(binding)

      upload! StringIO.new(result), fetch(:target_domain)
    end
  end

  task :enforce_config do
    on roles(:app) do
      execute :sudo, :cp, fetch(:target_domain), '/etc/nginx/sites-available'

      files_sites_available = capture(:find, '/etc/nginx/sites-available')
      files_sites_enabled = capture(:find, '/etc/nginx/sites-enabled')

      if files_sites_available.include?('/default')
        warn '[nginx:enforce_config] Deleting default config'
        execute :sudo, :rm, '/etc/nginx/sites-enabled/default'
        execute :sudo, :rm, '/etc/nginx/sites-available/default'
      end

      if files_sites_enabled.include?(fetch(:target_domain))
        warn '[nginx:enforce_config] Recreating symlink'
        execute :sudo, :rm, "/etc/nginx/sites-enabled/#{fetch(:target_domain)}"
      end

      execute :sudo, :ln, '-s',
                          "/etc/nginx/sites-available/#{fetch(:target_domain)}",
                          "/etc/nginx/sites-enabled/#{fetch(:target_domain)}"
    end
  end

  task :verify_and_restart do
    on roles(:app) do
      execute :sudo, :nginx, '-t'
      execute :sudo, :systemctl, :restart, :nginx
    end
  end
end
