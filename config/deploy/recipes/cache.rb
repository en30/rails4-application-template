namespace :cache do
  desc "Flush cache"
  task :clear, :roles => :web do
    run "cd #{latest_release} && bundle exec rake cache:clear RAILS_ENV=#{rails_env}"
  end
end
