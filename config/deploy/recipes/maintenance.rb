namespace :maintenance do
  desc "Maintenance start"
  task :on, :roles => :app do
    on_rollback { run "rm #{current_path}/tmp/maintenance.yml" }
    page = File.read("config/maintenance.yml")
    put page, "#{current_path}/tmp/maintenance.yml", :mode => 0644
  end

  desc "Maintenance stop"
  task :off, :roles => :app do
    run "rm #{current_path}/tmp/maintenance.yml"
  end
end
