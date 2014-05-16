namespace :remote_rake do
  desc "Run a task on a remote server."
  task :invoke, :roles => :rake do
    run("cd #{latest_release}; /usr/bin/env bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end
