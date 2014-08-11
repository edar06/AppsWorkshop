rails_env = ENV['RAILS_ENV'] || 'production'

threads 4,8

bind  "unix:///home/deployer/apps/payment_ops_ui/shared/sockets/puma.sock"
pidfile "/home/deployer/apps/payment_ops_ui/shared/sockets/puma.pid"
state_path "/home/deployer/apps/payment_ops_ui/shared/sockets/puma.state"
environment "production"

activate_control_app
