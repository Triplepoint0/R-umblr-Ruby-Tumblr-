require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require "./models"

# ...beginning of file

# this will ensure this will only be used locally
configure :development do
  set :database, "sqlite3:[name of database file]"
end

# this will ensure this will only be used on production
configure :production do
  # this environment variable is auto generated/set by heroku
  #   check Settings > Reveal Config Vars on your heroku app admin panel
  set :database, ENV["DATABASE_URL"]
end

# ...rest of file

get "/" do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :signed_home
  else
    erb :index
  end
end


# responds to sign in form
post "/" do
  @user = User.find_by(username: params[:username])
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:info] = "Welcome "
    redirect "/profile"
  else
    flash[:warning] = "Your username or password is incorrect"
    redirect "/"
  end
end


get "/sign-up" do
  erb :sign_up
end

#get "/profile" do
#  erb :users
#end





post "/sign-up" do
  @user = User.create(
    username: params[:username],
    password: params[:password]
  )
  session[:user_id] = @user.id
  flash[:info] = "Welcome #{params[:name]}"
  redirect "/"
end




get "/sign-out" do
  # this is the line that signs a user out
  session[:user_id] = nil
  erb :sign_out
end

