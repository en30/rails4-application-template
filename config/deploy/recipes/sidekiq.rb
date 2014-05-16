namespace :sidekiq do
  task :monit, :roles => :sidekiq do
    config = template('monit/sidekiq.conf.erb')
    put config, "/tmp/#{application}_sidekiq.conf"
    run "#{sudo} mv /tmp/#{application}_sidekiq.conf /etc/monit.d/#{application}_sidekiq.conf"
    run "#{sudo} chown root:root /etc/monit.d/#{application}_sidekiq.conf"
    run "#{sudo} chmod 700 /etc/monit.d/#{application}_sidekiq.conf"
  end

  task :stop_all, :roles => :sidekiq do
    run 'pkill -TERM -f sidekiq'
  end
end
