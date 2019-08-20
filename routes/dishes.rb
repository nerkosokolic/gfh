#only reads  not posts
get '/dishes/new' do
    erb :new
  end

  get '/dishes' do
    @dishes = Dish.all
    erb :index
end

get '/api/dishes' do
  content_type :json
  Dish.all.to_json
end


get '/' do
  @dishes = Dish.order(:created_at => 'desc').limit(3)
# notice that we chained the above with order and limit
  erb :home   #new page created
#tip Dish.limit(3).to_sql  - shows the SQL under the hood
end

  post '/dishes' do
    dish = Dish.new
    dish.title = params[:title]
    dish.image_url = params[:image_url]
    dish.user_id = current_user.id
    dish.save
    redirect '/'
  end
  
  get '/dishes/:id' do
    redirect '/login' unless session[:user_id]
    @dish = Dish.find(params[:id])
    @comments = Comment.where(dish_id: params[:id])
    erb :show
  end
  
  # to view the edit form
  get '/dishes/:id/edit' do
    @dish = Dish.find(params[:id])
    erb :edit
  end
  
  #update existing dish
  put '/dishes/:id' do
    #grab existing dish
    dish = Dish.find(params[:id])
    dish.title = params[:title]
    dish.image_url = params[:image_url]
    dish.save
    redirect "/dishes/#{params[:id]}"
  end
  
  delete '/dishes/:id' do
    dish = Dish.find(params[:id])
    dish.destroy
    redirect "/"
  end