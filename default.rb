# overriding Thor::Actions#source_paths
def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def after_bundle_install(&callback)
  @callbacks ||= []
  @callbacks << callback
end

def bundle_install
  run 'bundle install'
  @callbacks.each {|c| c.call }
end

@app_name = File.basename(destination_root)

# forcefully reinitialize Gemfile
run 'cp /dev/null Gemfile'
add_source 'https://rubygems.org'

gem 'rails', '~>4.0.3'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'slim-rails'
gem 'devise'
gem 'exception_notification'
gem 'kaminari'
gem 'counter_culture'
gem 'jbuilder', '~> 1.2'

gem_group :doc do
  gem 'sdoc', require: false
end

gem_group :development do
  gem 'rack-mini-profiler'
  gem 'guard-livereload', '~> 2.1.1', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'capistrano', '~> 2.0'
  gem "capistrano-ext"
  gem 'hipchat'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'annotate'
  gem 'faker'
  gem 'pry-rails'
  gem 'awesome_print'
end

gem_group :test do
  gem 'capybara'
  gem 'rb-fsevent', require: false
  gem 'growl'
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'terminal-notifier-guard'
end

gem_group :production, :staging do
  gem 'unicorn'
end

gem_group :production do
  gem 'newrelic_rpm'
end

# Settingslogic
gem 'settingslogic'
copy_file 'app/models/settings.rb'
copy_file 'config/constants.yml'

bundle_install
