class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :initialize_school

  def initialize_school
    @school ||= current_user.school if current_user.present? && !current_user.admin?
  end
end
