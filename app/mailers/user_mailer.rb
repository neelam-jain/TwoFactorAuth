class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirmation Email')
  end
end
