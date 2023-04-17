class WelcomeController < ApplicationController
  def index
    if current_user.present? && current_user.school_admin?
      @school = current_user.school
    end
  end
end
