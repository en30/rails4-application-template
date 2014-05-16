namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path};touch #{shared_path}/log/unicorn.log; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end
  task :restart, :roles => :app do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :stop, :roles => :app do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  namespace :assets do
    task :precompile, roles: lambda{ assets_role }, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end
