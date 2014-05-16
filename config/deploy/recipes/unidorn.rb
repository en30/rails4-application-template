namespace :unicorn do
  task :kill_old, :roles => :app do
    run 'pkill -TERM -f "master \(old\)"'
  end

  task :winch, :roles => :app do
    run 'pkill -WINCH -f "unicorn_rails master"'
  end

  task :kill, :roles => :app do
    run 'pkill -KILL -f "unicorn_rails"'
  end

  task :config, :roles => :app do
    config = template('unicorn.rb.erb')
    put config, "#{current_path}/config/unicorn.rb"

    config = template('monit/unicorn.conf.erb')
    put config, "/tmp/#{application}_unicorn.conf"
    run "#{sudo} mv /tmp/#{application}_unicorn.conf /etc/monit.d/#{application}_unicorn.conf"
    run "#{sudo} chown root:root /etc/monit.d/#{application}_unicorn.conf"
    run "#{sudo} chmod 700 /etc/monit.d/#{application}_unicorn.conf"
  end
end
