server '10.250.12.124', user: 'deployer', roles: %w{app db}
set :branch, 'master'
set :rails_env, 'staging'

set :ssh_options, {
  forward_agent: true,
}

set :rake, "bundle exec rake"
