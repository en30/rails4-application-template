set :rails_env, 'production'

ssh_options[:keys] = %w{~/.ssh/id_rsa}
ssh_options[:port] = ''
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/home/#{user}/rails_projects/#{application}"

set :web_servers, []
set :app_servers,  []
set :sidekiq_servers, []

set :sidekiq_role, :sidekiq
role :sidekiq, *sidekiq_servers

role :web, *web_servers
role :app, *app_servers
role :db, app_servers[0],  :primary => true
role :rake, app_servers[0]

set :unicorn_processes, 10
