set :application, 'Oplerno'
set :rails_env, 'production'

set :scm, :git
set :repo_url, 'git@github.com:webhat/oplerno.git'
set :branch, 'develop'

set :deploy_to, '/home/redhat/www'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config/strongbox}

set :format, :pretty
set :log_level, :debug
set :pty, true
set :keep_releases, 4

set :default_env, {
    'DEVISE_SECRET' => ENV['DEVISE_SECRET'],
    'DEVISE_PEPPER' => ENV['DEVISE_PEPPER'],
    'DB' => 'mysql',
    'RAILS_ENV' => fetch(:rails_env),
    'CANVAS_USERNAME' => ENV['CANVAS_USERNAME'],
    'CANVAS_PASSWORD' => ENV['CANVAS_PASSWORD'],
    'CANVAS_TOKEN' => ENV['CANVAS_TOKEN']
}

namespace :deploy do
  before :starting, 'github:ssh'

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 0 do
      within release_path do
          execute "cd #{release_path} ; DEVISE_SECRET=#{fetch(:default_env)['DEVISE_SECRET']} DEVISE_PEPPER=#{fetch(:default_env)['DEVISE_PEPPER']} /tmp/Oplerno/rvm-auto.sh ruby-1.9.3-p448 bin/unicorn_rails -c config/unicorn.rb -E #{fetch(:rails_env)}|| echo ''"
      end
    end
  end

  desc 'Sync with Canvas'
  task :sync do
    on roles(:db), in: :sequence, wait: 5 do
      within release_path do
        execute :rake, 'cron'
      end
    end
  end


  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 0 do
      # Your restart mechanism here, for example:
      execute :touch, shared_path.join('tmp/pids/unicorn.pid')
      execute "kill -USR2 `cat #{shared_path.join('tmp/pids/unicorn.pid')}` || echo ''"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 1 do
      # Here we can do anything such as:
      within release_path do
        # nothing
      end
    end
  end

  after :updated, 'deploy:migrate'

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

