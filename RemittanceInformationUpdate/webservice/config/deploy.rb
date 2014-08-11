# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'payment_ops_webservice'
set :repo_url, 'git@github.com:TraxTechnologies/payment_ops_webservice.git'

set :deploy_to, '/usr/local/apps/rails'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within "#{current_path}" do
        puts "hard restart"
        execute "/etc/init.d/puma", "restart"
      end
    end
  end

end
