# User to connect to your server
set :user, 'localtunnel'
# Your server domain
server "localtunnel.example.com", user: fetch(:user), roles: %w{app}

# Your target domain. Ideally can be the same
# as server's domain
set :target_domain, "localtunnel.example.com"

# Your subdomain wildcard. You can leave it as-is
set :target_subdomain, "*.#{fetch(:target_domain)}"

# DO Token required to provision Wildcard SSL
# using let's encrypt
set :digitalocean_api_token, "dop_v1_yourtoken"

# Your email for registering certbot
set :certbot_email, "your@example.com"
