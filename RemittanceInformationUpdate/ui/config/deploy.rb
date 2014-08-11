# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'payment_ops_ui'
set :repo_url, 'git@github.com:TraxTechnologies/payment_ops_ui.git'

set :deploy_to, '/usr/local/apps/rails'


#set :log_level, :debug

set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

#rails specific options
set :assets_roles, [:web, :app]
#set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

#SSHKit.config.command_map[:pumactl] = "bundle exec"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{current_path}" do
        execute :bundle, "exec pumactl", "-F", "/etc/puma.rb", "restart"
      end
    end
  end

  after :publishing, :restart

end
