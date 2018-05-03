require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require "./models"

set :database, "sqlite3:app.db"
enable :sessions

configure :developement do 
  set :database, "sqlite3:app.db"
end

configure :production do 
  set :database, ENV["DATABASE_URL"]
end

enable session



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

