
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
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
