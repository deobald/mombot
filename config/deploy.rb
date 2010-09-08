
app_root = "/users/home/deobald/railsapps/mombot"
current_app_root = "#{app_root}/current"

set :application, "mombot"
set :repository,  "git://github.com/deobald/mombot.git"
set :scm, :git

set :user, "deobald"
set :domain, "deobald.ca"
set :use_sudo, false
set :deploy_to, "/users/home/deobald/railsapps/mombot"
#set :path, "/users/home/#{user}"
#set :port, 3000
#set :apps_directory, "railsapps"

role :web, domain
role :app, domain
role :db,  domain, :primary => true

after "deploy:symlink", :fix_production_config
after "deploy:restart", "deploy:stop", "deploy:start"

namespace :deploy do
  task :start do
    run "#{current_app_root}/script/spin"
  end

  task :stop do
    run "#{current_app_root}/script/unspin"
  end

  task :restart do
  end
end

task :fix_production_config do
  run "#{app_root}/fix-production-config.rb"
end
