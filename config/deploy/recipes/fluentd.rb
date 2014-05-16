namespace :fluentd do
  desc "Add fluentd configurations for app"
  task :setup, :roles => :app do
    config = tempalte('fluentd/app.conf.erb')
    put config, "/tmp/#{application}.conf"
    run "#{sudo} mv /tmp/#{application}.conf /etc/td-agent/conf.d/#{application}.conf"
  end

  desc "Add fluentd configurations for nginx"
  task :nginx_setup, :roles => :web do
    config = template('fluentd/nginx.conf.erb')
    put config, "/tmp/#{application}"
    run "#{sudo} mv /tmp/#{application} /etc/td-agent/conf.d/nginx.#{application}.conf"
  end

  desc "Restart fluentd"
  task :restart, :roles => [:app, :web] do
    run "#{sudo} /etc/init.d/td-agent restart"
  end
end
