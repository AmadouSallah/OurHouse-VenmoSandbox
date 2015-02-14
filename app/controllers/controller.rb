get '/' do
  erb :index, layout: false
end

get '/venmo_auth' do
  venmo_authorize
  redirect '/'
end
