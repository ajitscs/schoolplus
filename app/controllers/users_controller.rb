class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :initialize_user, only: %I[show update edit destroy]

  def index
    if current_user.admin?
      @users = User.all.order_by_recent
    elsif current_user.school_admin?
      @school = current_user.school
      @users = User.with_role(:student).with_school(@school.id).order_by_recent
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "user has been created successfully"
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages.join("<br>").html_safe
      render action: :new
    end
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    if @user.save
      flash[:notice] = "user has been update successfully"
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join("<br>").html_safe
      render action: :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "user has been deleted successfully"
    else
      flash[:error] = @user.errors.full_messages.join("<br>").html_safe
    end
    redirect_to users_path
  end

  private

  def user_params
    if current_user.school_admin?
      params[:user][:role] = "student"
      params[:user][:school_id] = current_user.school.id
    end
    params.require(:user).permit(:email, :first_name, :last_name, :role, :contact, :school_id)
  end

  def initialize_user
    @user = User.find_by(id: params[:id])
    unless @user.present?
      flash[:error] = "User not found"
      redirect_to root_path and return
    end 
  end
end
