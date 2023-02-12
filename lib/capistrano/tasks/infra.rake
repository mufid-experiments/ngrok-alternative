namespace :infra do
  task :reboot do
    on roles(:app) do
      execute :sudo, :reboot
    end
  end

  task :load_ip do
    on roles(:app) do
      curl_result = capture(:curl, '-sS', 'https://ipinfo.io')
      server_ip = JSON.parse(curl_result)["ip"]

      info "SET Server IP: #{server_ip}"
      set :server_ip, server_ip
    end
  end
end
