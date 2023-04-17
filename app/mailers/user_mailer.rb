class UserMailer < ApplicationMailer
  def send_password(user, password)
    @greeting = "Hi, #{user.full_name}"
    @password = password

    mail to: user.email
  end
end