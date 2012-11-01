set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
require 'sidekiq/capistrano'

set :application, "veggie"
set :repository,  "git@github.com:kkxlkkxllb/veggie.git"

set :rvm_type, :user
set :scm, :git
set :scm_username, "kkxlkkxllb@gmail.com"
set :keep_releases, 3   # 留下多少个版本的源代码
set :user,      "www"   # 服务器 SSH 用户名
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"
set :deploy_to, "~/#{application}/"
role :web, "106.187.91.220"                          # Your HTTP server, Apache/etc
role :app, "106.187.91.220"                          # This may be the same as your `Web` server
role :db,  "106.187.91.220", :primary => true # This is where Rails migrations will run
#role :db,  "106.187.91.220"
set :use_sudo,  false
set :deploy_via, :remote_cache

# unicorn config
set :rails_env, :production
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  desc "Reload unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do   
    run "cat #{unicorn_pid};touch #{current_path}/tmp/restart.txt;kill -USR2 `cat #{unicorn_pid}`"
		  
    # run "kill -QUIT `cat #{unicorn_pid}`" 
    # sleep(10)
    # run "cd #{current_path} && bundle exec unicorn_rails -c config/unicorn.rb -E production -D"
  end

  desc "migrate"
  task :migration,:roles => :app do      
    run "cd #{current_path} && bundle exec rake db:migrate RAILS_ENV=production"
  end
  
  task :restart_resque, :roles => :app do
      pid_file = "#{current_path}/tmp/pids/resque.pid"
      run "test -f #{pid_file} && cd #{current_path} && kill -s QUIT `cat #{pid_file}` || rm -f #{pid_file}"
      run "cd #{current_path} && PIDFILE=#{pid_file} RAILS_ENV=production BACKGROUND=yes QUEUE=* bundle exec rake environment resque:work"
  end
end

after 'deploy:update_code' do  
    softlinks = [
      "ln -nfs #{deploy_to}shared/config/unicorn.rb #{release_path}/config/unicorn.rb",
      "ln -nfs #{deploy_to}shared/config/database.yml #{release_path}/config/database.yml",
      "ln -nfs #{deploy_to}shared/config/service.yml #{release_path}/config/service.yml"
    ]
    run "#{softlinks.join(';')}"
 
    run "cd #{release_path} && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile"  
    #run "RAILS_ENV=production resque-web #{current_path}/config/initializers/resque.rb"      
end
# if you want to clean up old releases on each deploy uncomment this:
#after 'deploy:restart', 'deploy:restart_resque'
after "deploy:restart", "deploy:cleanup"