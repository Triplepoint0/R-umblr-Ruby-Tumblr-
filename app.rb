require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require "./models"

# ...beginning of file

# this will ensure this will only be used locally
configure :development do
  set :database, "sqlite3:app.db"
end

# this will ensure this will only be used on production
configure :production do
  # this environment variable is auto generated/set by heroku
  #   check Settings > Reveal Config Vars on your heroku app admin panel
  set :database, ENV["DATABASE_URL"]
end

# ...rest of file
enable :sessions

get "/" do
  if session[:user_id]
    @posts = Post.all
    @user = User.find(session[:user_id])
    @post = Post.create(
      title: params[:title],
      post: params[:post]
    )
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
    flash[:info] = "Welcome #{params[:username]}"
    redirect "/"
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
    password: params[:password],
    first_name: params[:first_name],
    last_name: params[:last_name],
    birthday: params[:birthday]
  )

  # @post = Post.create(
  #   title: params[:title],
  #   post: params[:post]
  # )

  session[:user_id] = @user.id
  flash[:info] = "Welcome #{params[:username]}"
  redirect "/"
end

get "/sign-out" do
  # this is the line that signs a user out
  session[:user_id] = nil
  erb :sign_out
end

post "/posts" do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @post = Post.create(
      title: params[:title],
      post: params[:post]
    )
    @post = Post.all
    
    erb :posts
  else
    erb :index
  end
end

get "/posts" do
  @post = Post.create(
    title: params[:title],
    post: params[:post],
    user_id: params[:user_id]
  )
end

# ##get "/posts/:user_id" do
#   @post = Post.create(
#     title: params[:title],
#     post: params[:post],
#     user_id: params[:user_id]
#   )
# end

# post "/posts/:user_id" do
#   erb :index
# end 

# get "/posts/:user_id" do
#   @post = Post.find(params[:user_id])
#  end

# delete "/posts/:user_id" do
# 	@post = Post.find(params[:user_id])
# 	@post.destroy
# 	redirect '/'

get "/posts/:user_id" do
  @post = Post.find(params[:user_id])
  erb :posts_page
 end

 delete '/posts/:user_id' do
	@post = Post.find(params[:user_id])
	@post.destroy
	redirect '/'
end

get "/deleteuser" do
 if session[:user_id]
     @post = Post.all
     @post.each do |post|
         if (post.user_id == session[:user_id] )
             post.destroy
         else
             next
         end  
     end      
     # @id = session[:user_id]
     @user = User.find(session[:user_id]).destroy
     # @posts = Post.find_by(user_id: @id).destroy
     
     session[:user_id] = nil
 end
erb :index
end