get '/login' do
    erb :login
  end
  
post '/sessions' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
  session[:user_id] = user.id #its a hash - named session
  redirect "/"
  else 
    erb :login
  end
end
  
delete '/sessions' do
  session[:user_id] = nil
  redirect '/login'
end