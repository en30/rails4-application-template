namespace :monit do
  task :restart, roles: [:app, :sidekiq] do
    run "#{sudo} initctl restart monit"
  end
end
