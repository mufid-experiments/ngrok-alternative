namespace :localtunnel do
  task :install do
    invoke 'infra:load_ip'
    invoke 'localtunnel:apt_update'
    invoke 'localtunnel:apt_nginx'
    invoke 'letsencrypt:install'
    invoke 'nginx:setup'
    invoke 'localtunnel:instruction'
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

  task :instruction do
    on roles(:app), in: :parallel do |host|
      info 'Done!'
      info 'Use following command to port forward'
      info "your localhost:8080 to forward-5000.#{fetch(:target_domain)}"
      info ''
      info "     ssh -N -T -R 5000:localhost:8080 #{fetch(:user)}@#{fetch(:target_domain)}"
      info ''
      info 'You can change 8080 to any of your local port. It can be 5000 as well.'
    end
  end
end
