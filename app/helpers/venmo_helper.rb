helpers do
  include HTTParty

  def venmo_auth_url
    return "https://api.venmo.com/v1/oauth/authorize?client_id=#{ENV['VENMO_CLIENT_ID']}&scope=make_payments%20access_profile%20access_email%20access_phone%20access_balance&response_type=code"
  end

  def venmo_auth_code
    return params[:code] if params[:code]
  end

  def venmo_authorize
    url = "https://api.venmo.com/v1/oauth/access_token"
    @venmo_response = HTTParty.post(url, :query => {
      client_id: ENV['VENMO_CLIENT_ID'],
      client_secret: ENV['VENMO_SECRET'],
      code: venmo_auth_code })
    capture_venmo_access_token
  end

  def capture_venmo_access_token
    response = JSON.parse(@venmo_response.to_json)
    current_user.update(venmo_access_token: response["access_token"]) if response["access_token"]
  end

  def current_user
    @current_user ||= User.find(1)
  end

  def create_venmo_payment
    url = "https://sandbox-api.venmo.com/v1/payments"
    @venmo_payment_response =
      HTTParty.post(url, :query => payment_params)
    capture_payment_response
  end

  def capture_payment_response
    response = JSON.parse(@venmo_payment_response.to_json)["data"]
    @payment = Payment.new(user_id: current_user.id,
                   payment_to: response["payment"]["target"]["user"]["id"],
                   amount: response["payment"]["amount"].to_f,
                   note: response["payment"]["note"],
                   venmo_payment_id: response["payment"]["id"],
                   venmo_payment_status: response["payment"]["status"]
                   )
  end

  def payment_successful?
    # debugger
    true if @payment.save && @payment.venmo_payment_status == "settled"
    # @payment.save && @payment.venmo_payment_status == "settled"

  end

  def payment_params
    {email: params[:receivers_email],
     note: params[:payment_note],
     amount: params[:payment_amount].to_f,
     access_token: current_user.venmo_access_token}
  end

end
