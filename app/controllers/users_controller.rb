class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Send confirmation email
      UserMailer.confirmation_email(@user).deliver_now
      redirect_to root_path, notice: 'User Successfully Created! Please check your email for confirmation instructions.'
    else
      render :new
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:confirmation_token])
    if user
      user.update(confirmed: true)
      redirect_to root_path, notice: 'Email confirmed successfully.'
    else
      redirect_to root_path, alert: 'Invalid confirmation token.'
    end
  end

  def enable_otp
    current_user.two_fa_enabled
    # Assume you have a method to display the QR code to the user
    render :show_qr_code
  end

  def show_qr_code
    # Display the QR code to the user using the otp_provisioning_uri method
    @qr_code_uri = current_user.otp_provisioning_uri
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
