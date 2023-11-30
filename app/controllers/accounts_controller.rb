# app/controllers/account_controller.rb
class AccountsController < ApplicationController
  before_action :require_login, only: [:edit, :update_password, :enable_two_factor, :disable_two_factor]

  def edit
  end

  def edit_password
  end

  def update_password
    if current_user&.authenticate(params[:user][:current_password])
      if current_user.update(password: params[:user][:new_password])
        redirect_to edit_accounts_path, notice: 'Password updated successfully.'
      else
        flash.now[:alert] = 'Failed to update password.'
        render :edit
      end
    else
      flash.now[:alert] = 'Current password is incorrect.'
      render :edit
    end
  end

  def enable_two_factor
    current_user.enable_two_factor_authentication
    redirect_to edit_accounts_path, notice: 'Two-factor authentication enabled. Scan the QR code with your authenticator app.'
  end

  def disable_two_factor
    current_user.update(two_fa_enabled: false, otp_secret_key: nil)
    redirect_to edit_accounts_path, notice: 'Two-factor authentication disabled.'
  end

  private

  def require_login
    unless logged_in?
      redirect_to root_path, alert: 'You must be logged in to access this page.'
    end
  end
end
