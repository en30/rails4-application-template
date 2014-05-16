namespace :db do
  desc 'Create database for this Rails application'
  task :create, :roles => :db do
    run "cd #{latest_release}; bundle exec rake db:create RAILS_ENV=#{rails_env}"
  end

  desc 'Insert seeds'
  task :seed, :roles => :db do
    run "cd #{latest_release}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end
