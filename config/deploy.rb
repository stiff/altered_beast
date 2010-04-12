set :application, "Forum"
set :user, "caelum"
set :repository,  "http://github.com/caelum/novoforum.git"

set :scm, :git
set :scm_verbose, true

role :web, "97.74.206.156"                          # Your HTTP server, Apache/etc
role :app, "97.74.206.156"                          # This may be the same as your `Web` server
role :db,  "97.74.206.156", :primary => true # This is where Rails migrations will run


set :use_sudo, false

set :deploy_to, "/home/#{user}/webapps/#{application}" 

set :domain, "#{user}@#{application}"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
   run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

# before run this task is necessary create database.yml file in /webapps/loja-virtual/shared/config directory.
# more details in http://archive.jvoorhis.com/articles/2006/07/07/managing-database-yml-with-capistrano
  desc "SymbolLink production database.yml" 
  task :after_default do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{current_path}/config/database.yml" 
  end
end
