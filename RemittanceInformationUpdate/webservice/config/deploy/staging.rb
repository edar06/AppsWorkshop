server '10.250.12.134', user: 'deployer', roles: %w{app}

set :branch, 'master'

set :ssh_options, {
  forward_agent: true,
}


