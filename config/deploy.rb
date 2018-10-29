# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "solvision"
set :repo_url, "git@github.com:shallontecbiz/solvision.git"
set :deploy_to, "/home/ec2-user/rails_apps/solvision"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :keep_releases, 1
set :bundle_without,  [:development, :test]
set :user, "ec2-user"
set :group, "ec2-user"

set :rbenv_custom_path, '/usr/local/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl}
set :rbenv_roles, :all # default value

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v8.9.4'
set :nvm_map_bins, %w{node npm yarn}

set :npm_target_path, -> { release_path }
set :npm_flags, '--production --silent --no-progress'
set :npm_roles, :all
set :npm_env_variables, {}

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :bundle_binstubs, nil
set :linked_files, fetch(:linked_files, []).push('.env')
append :linked_files, "config/puma.rb"
append :linked_files, "config/master.key"
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle node_modules public/.well-known}

set :nginx_use_ssl, true
set :nginx_ssl_certificate, '/etc/letsencrypt/live/solar.shallontec.biz/fullchain.pem'
set :nginx_ssl_certificate_key, '/etc/letsencrypt/live/solar.shallontec.biz/privkey.pem'

set :ssh_options, {
  # user: 'ec2-user',
  forward_agent: true,
  auth_methods: %w(publickey)
}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/solvision
# set :deploy_to, "/var/www/solvision"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Puma Default Settings
# set :puma_user, fetch(:user)
# set :puma_rackup, -> { File.join(current_path, 'config.ru') }
# set :puma_state, "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
# set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
# set :puma_control_app, false
# set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
# set :puma_conf, "#{shared_path}/puma.rb"
set :puma_conf, "#{shared_path}/config/puma.rb"
# set :puma_access_log, "#{shared_path}/log/puma_access.log"
# set :puma_error_log, "#{shared_path}/log/puma_error.log"
# set :puma_role, :app
# set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
# set :puma_threads, [0, 16]
# set :puma_workers, 0
# set :puma_worker_timeout, nil
# set :puma_init_active_record, false
# set :puma_preload_app, false
set :puma_preload_app, false
# set :puma_daemonize, false
# set :puma_plugins, []  #accept array of plugins
# set :puma_tag, fetch(:application)

# Puma::Nginx Default Settings
# set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}"
# set :nginx_flags, 'fail_timeout=0'
# set :nginx_http_flags, fetch(:nginx_flags)
# set :nginx_server_name, "localhost #{fetch(:application)}.local"
# set :nginx_sites_available_path, '/etc/nginx/sites-available'
# set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'
# set :nginx_socket_flags, fetch(:nginx_flags)
# set :nginx_ssl_certificate, "/etc/ssl/certs/#{fetch(:nginx_config_name)}.crt"
# set :nginx_ssl_certificate_key, "/etc/ssl/private/#{fetch(:nginx_config_name)}.key"
# set :nginx_use_ssl, false

set :prune_bundler, true

require 'seed-fu/capistrano3'
before 'deploy:publishing', 'db:seed_fu'

