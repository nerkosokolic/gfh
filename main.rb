
require 'sinatra'
require 'sinatra/reloader'

also_reload File.expand_path(__dir__, 'models/*')
also_reload File.expand_path(__dir__, 'views/*')
also_reload File.expand_path(__dir__, 'routes/*')

require_relative 'database_config'

require_relative 'models/dish'
require_relative 'models/comment'
require_relative 'models/user'
require_relative 'models/category'
require_relative 'models/like'



# allows for it to remember 
enable :sessions

#make methods also be available in templates
helpers do
  def logged_in? # predicate method returns true or false
    if current_user
      return true
    else 
      return false
    end
    #alternative is !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

end


get '/' do
  @dishes = Dish.order(:created_at => 'desc').limit(3)
# notice that we chained the above with order and limit
  erb :home   #new page created
#tip Dish.limit(3).to_sql  - shows the SQL under the hood
end

get '/my_dishes' do
  @dishes = Dish.where(user_id: current_user.id) #more than one find gives back only one
  erb :my_dishes
end

post '/likes' do
  redirect "/login" unless logged_in?
  like = Like.new
  like.dish_id = params[:dish_id]
  like.user_id = current_user.id
  like.save
  redirect '/'
end

post '/api/likes' do
  content_type :json
  like = Like.new
  like.dish_id = params[:dish_id]
  like.user_id = current_user.id
  if like.save
    { message: "we are good buddy!", likes_count: Like.where(dish_id: like.dish_id).count }.to_json
  else
    { message: "unsuccesful"}.to_json
  end
end

require_relative 'routes/dishes'
require_relative 'routes/comments'
require_relative 'routes/sessions'


after do
  ActiveRecord::Base.connection.close
end
# CREATE TABLE comments (
  #   id SERIAL PRIMARY KEY,
  #   body TEXT,
  #   dish_id INTEGER
  # );
  
#   CREATE TABLE users (
#       id SERIAL PRIMARY KEY,
#       email VARCHAR(300),
#       password_digest VARCHAR(400)
# );

# ALTER TABLE dishes ADD COLUMN user_id INTEGER;
# ALTER TABLE comments ADD COLUMN user_id INTEGER;
# INSERT INTO comments (body, dish_id) VALUES ('yucky', 1);

#Entity Relationship Diagram - i.e. one to many diagram
#Crows feet to 1 

# Authentication - proving who you are
# Stateless means theres is no conversation
# you make a request and it response

# It wont remember what you said before

  # Goes through a one way function that hashes a password
  # it digests the input and produces the same output

  # We installed BCRYPT

