# config valid only for current version of Capistrano
lock '3.9.1'

set :application, 'minecraft-manager'
set :repo_url, 'git@github.com:J3RN/minecraft-manager.git'

# Configure RVM
set :rvm_type, :system
set :rvm_ruby_version, '2.2.8'

# Default value for :linked_files is []
append :linked_files, '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids'

task :restart_sidekiq do
  on roles(:worker) do
    execute :systemctl, '--user restart sidekiq'
  end
end
after 'deploy:published', 'restart_sidekiq'
