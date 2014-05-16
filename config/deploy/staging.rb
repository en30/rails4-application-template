set :rails_env, 'staging'

ssh_options[:keys] = %w{~/.vagrant.d/insecure_private_key}
ssh_options[:port] = "22"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/home/#{user}/rails_projects/#{application}"

set :app_servers, []
set :sidekiq_role, :sidekiq
role :sidekiq, *app_servers
role :web, ''
role :app, *app_servers
role :db, '',  :primary => true

set :unicorn_processes, 2
