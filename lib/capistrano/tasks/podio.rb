namespace :podio do
  desc 'Update CanvasUsers and CanvasCourses'
  task :users do
    on roles(:db), in: :sequence, wait: 5 do
      execute "cd #{release_path} ; DB=mysql PAYPAL_USER='production' PAYPAL_PASS='production' PAYPAL_SIG='production' RAILS_ENV=production CANVAS_TOKEN=#{fetch(:default_env)['CANVAS_TOKEN']} MAIL_PASSWORD=#{fetch(:default_env)['MAIL_PASSWORD']} AUTHY_API_KEY=#{fetch(:default_env)['AUTHY_API_KEY']} NEWRELIC_KEY=#{fetch(:default_env)['NEWRELIC_KEY']} OPLERNO_TOKEN=#{fetch(:default_env)['OPLERNO_TOKEN']} OPLERNO_KEYBASE=#{fetch(:default_env)['OPLERNO_KEYBASE']} DEVISE_SECRET=#{fetch(:default_env)['DEVISE_SECRET']} DEVISE_PEPPER=#{fetch(:default_env)['DEVISE_PEPPER']} PODIO_CID=#{fetch(:default_env)['PODIO_CID']} PODIO_SECRET=#{fetch(:default_env)['PODIO_SECRET']} PODIO_USERNAME=#{fetch(:default_env)['PODIO_USERNAME']} /tmp/Oplerno/rvm-auto.sh ruby-2.0.0-p481 bundle exec rake cron:courses"
    end
  end
end
