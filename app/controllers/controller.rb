get '/' do
  erb :index, layout: false
end

get '/venmo_auth' do
  venmo_authorize
  redirect '/'
end

post '/venmo_payment' do
  create_venmo_payment
  if payment_successful?
    @payment = "It worked!"
  else
    @payment = "ya fucked up!"
  end
  erb :index
end
