namespace :nginx do
  desc "Adds NginX configuration and enables it."
  task :setup , :roles => :web do
    config = template('nginx.conf.erb')
    put config, "/tmp/#{application}"
    run "#{sudo} mv /tmp/#{application} /etc/nginx/conf.d/#{application}.conf"
  end

  desc "Restarts nginx"
  task :restart, :roles => :web do
    run "#{sudo} service nginx restart"
  end

  desc "Removes NginX configuration and disables it."
  task :destroy, :roles => :web do
    puts "\n\n=== Removing NginX Virtual Host for #{web}! ===\n\n"
    begin
      run "#{sudo} rm /etc/nginx/conf.d/#{application}.conf"
    ensure
      system 'cap nginx:restart'
    end
  end
end
