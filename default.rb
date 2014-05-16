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

# default configurations
application <<-CONFIG
config.time_zone = 'Tokyo'
config.encoding = 'utf-8'
config.i18n.default_locale = :ja
config.generators do |g|
  g.test_framework :rspec
  g.orm :active_record
  g.template_engine :slim
end
config.active_record.schema_format = :sql
CONFIG

environment <<-CONFIG, env: 'production'
config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options = { host: Settings.host }
config.middleware.use ExceptionNotification::Rack,
email: {
  email_prefix: '[#{@app_name}]',
  sender_address: %w{"notifier" <notifier@\#{Settings.host}>},
  exception_recipients: [Settings.exception_recipient]
}
CONFIG

# staging
run "cp config/environments/production.rb config/environments/staging.rb"
# database settings
append_to_file 'config/database.yml', <<-YML
staging:
  adapter: postgresql
  database: #{@app_name}
  username:
  password:
  encoding: utf8
  pool: 25
  timeout: 5000
  host:
  port: 5432
YML

# Rspec
after_bundle_install do
  generate 'rspec:install'
  directory 'spec'
  copy_file 'Guardfile'
end

# welcom page作成
after_bundle_install do
  generate :controller, 'welcome', 'index'
  route "root to: 'welcome#index'"
end

# devise
after_bundle_install do
  generate 'devise:install'
  generate 'devise', 'User'
  run 'curl https://raw.githubusercontent.com/tigrish/devise-i18n/master/locales/ja.yml -o config/locales/devise.ja.yml'
end

if yes? 'Use twitter?'
  gem 'omniauth-twitter'
  gem 'twitter', '~>5.0'
  copy_file 'app/models/client.rb'

  after_bundle_install do
    generate :migration, 'AddOmniauthColumnsToUsers', 'twitter_id:bigint', 'access_token:string', 'access_token_secret:string'
    p 'Write columns you need to the generated migration file'
    insert_into_file 'config/initializers/devise.rb', "\nconfig.omniauth :twitter, Settings.twitter.consumer_key, Settings.twitter.consumer_secret\n", before: "\nend"

    insert_into_file 'config/routes.rb', ", controllers: {omniauth_callbackes: 'users/omniauth_callbacks'}", after: 'devise_for :users'
    copy_file 'app/controllers/users/omniauth_callbacks_controller.rb'
    inject_into_file 'app/models/user.rb', <<-CODE, before: "\nend"

      devise :omniauthable, omniauth_providers: [:twitter]
      def self.find_for_twitter_oauth(auth, sign_in_resource=nil)
        user = sign_in_resource || User.find_or_initialize_by(twitter_id: auth.uid)
        user_info = auth.extra.raw_info
        raise user_info.errors[0].message if user_info.errors

        user.update!({
          twitter_id: auth.uid,
          access_token: auth.credentials.token,
          access_token_secret: auth.credentials.secret,
          #        name: user_info.name,
          #        description: user_info.description,
          #        twitter_screen_name: user_info.screen_name,
          #        profile_image_url: user_info.profile_image_url
        })
        user
      end
    CODE
  end
end

bundle_install
