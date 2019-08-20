post '/comments' do
    redirect '/login' unless session
    comment = Comment.new
    comment.body = params[:body]
    comment.dish_id = params[:dish_id]
    comment.user_id = current_user.id
    comment.save
    redirect "/dishes/#{params[:dish_id]}"
  end