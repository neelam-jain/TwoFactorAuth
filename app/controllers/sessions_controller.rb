class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      if @user.two_fa_enabled?
        session[:two_factor] = true
        @user.generate_otp_secret_key
        @user.send_otp
        redirect_to login_otp_path
      else
        log_in @user
        redirect_to dashboard_path, notice: 'Logged in successfully.'
      end
    else
      flash.now[:alert] = 'Invalid email or password.'
      render :new
    end
  end

  def login_otp
    # This is a placeholder action, render a form for the user to enter the OTP
  end

  def verify_otp
    if session["two_factor"]
      entered_otp = params[:session]["otp"]
      if current_user&.verify_otp(entered_otp)
        log_in current_user
        session.delete(:two_factor)
        redirect_to dashboard_path, notice: 'Two-factor authentication successful.'
      else
        flash.now[:alert] = 'Invalid OTP. Please try again.'
        render :login_otp
      end
    else
      redirect_to root_path, alert: 'Invalid request.'
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'Logged out successfully.'
  end
end
