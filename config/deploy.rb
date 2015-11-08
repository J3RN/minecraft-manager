require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'carp.j3rn.com'
set :deploy_to, '/var/www/minecraft-manager'
set :repository, 'git://github.com/j3rn/minecraft-manager'
set :branch, 'master'

# For system-wide RVM install.
set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.

# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['.env', 'log', 'pids']

# Optional settings:
set :user, 'j3rn'    # Username in the server to SSH to.
set :term_mode, nil

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.2.3@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]

  queue! %[touch "#{deploy_to}/#{shared_path}/.env"]

  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/.env"]

  queue %[
    repo=github.com &&
    repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
    repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
    if [ -z "${repo_port}" ]; then repo_port=22; fi &&
    ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  ]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'sidekiq:restart'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

namespace :sidekiq do
  # Sets the path to sidekiq.
  set_default :sidekiq, lambda { "#{bundle_bin} exec sidekiq" }

  # Sets the path to sidekiqctl.
  set_default :sidekiqctl, lambda { "#{bundle_prefix} sidekiqctl" }

  # Set the default sidekiq PID location
  set_default :sidekiq_pid, lambda { "#{deploy_to}/#{current_path}/pids/sidekiq.pid" }

  # Set the default sidekiq PID location
  set_default :sidekiq_log, lambda { "#{deploy_to}/#{current_path}/log/sidekiq.log" }

  desc "Quiet Sidekiq"
  task :quiet => :environment do
    queue %[echo "-----> Quiet sidekiq (stop accepting new work)"]
    queue %{
      if [ -f #{sidekiq_pid} ] && kill -0 `cat #{sidekiq_pid}`> /dev/null 2>&1; then
        cd "#{deploy_to}/#{current_path}"
        #{echo_cmd %[#{sidekiqctl} quiet #{sidekiq_pid}]}
      else
        echo 'Skip quiet command (no pid file found)'
      fi
    }
  end

  desc "Stop Sidekiq"
  task :stop => :environment do
    queue %[echo "-----> Stop sidekiq"]
    queue %[
      if [ -f #{sidekiq_pid} ] && kill -0 `cat #{sidekiq_pid}`> /dev/null 2>&1; then
        cd "#{deploy_to}/#{current_path}"
        #{echo_cmd %[#{sidekiqctl} stop #{sidekiq_pid}]}
      else
        echo 'Skip stopping sidekiq (no pid file found)'
      fi
    ]
  end

  desc "Start sidekiq"
  task :start => :environment do
    queue %[echo "-----> Start sidekiq"]
    queue %{
      cd "#{deploy_to}/#{current_path}"
      #{echo_cmd %[#{sidekiq} -d -e #{rails_env} -P #{sidekiq_pid} -L #{sidekiq_log}] }
    }
  end

  # ### sidekiq:restart
  desc "Restart sidekiq"
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
