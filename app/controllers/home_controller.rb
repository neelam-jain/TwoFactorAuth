# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :require_login

  def dashboard
  end

  private

  def require_login
    unless logged_in?
      redirect_to root_path, alert: 'You must be logged in to access this page.'
    end
  end
end
