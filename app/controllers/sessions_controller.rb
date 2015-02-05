class SessionsController < ApplicationController
  def new
  end

  def create
    s = session_params
    user = User.find_by_email(s[:email].downcase)
    if user && user.authenticate(s[:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
