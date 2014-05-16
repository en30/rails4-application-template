namespace :bundle do
  task :setuppg, :roles => [:app, :web, :sidekiq] do
    run "bundle config build.pg --with-pg-config=/usr/pgsql-9.2/bin/pg_config"
  end
end
