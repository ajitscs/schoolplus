class SchoolsController < ApplicationController
  load_and_authorize_resource
  before_action :initialize_school, only: %I[show update edit destroy]
  before_action :validate_school_admin, only: [:edit, :update, :show]

  def index
    @schools = School.all.order(id: :desc)#.paginate(page: params[:page])
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      flash[:success] = "School has been created successfully"
      redirect_to schools_path
    else
      flash[:error] = @school.errors.full_messages.join("<br>").html_safe
      render action: :new
    end
  end

  def edit
  end

  def update
    @school.assign_attributes(school_params)
    if @school.save
      flash[:notice] = "School has been update successfully"
      redirect_to school_path(@school)
    else
      flash[:error] = @school.errors.full_messages.join("<br>").html_safe
      render action: :edit
    end
  end

  def destroy
    if @school.destroy
      flash[:notice] = "School has been deleted successfully"
    else
      flash[:error] = @school.errors.full_messages.join("<br>").html_safe
    end
    redirect_to schools_path
  end

  private

  def school_params
    params.require(:school).permit(:title, :address, :contact)
  end

  def initialize_school
    @school = School.find_by(id: params[:id])
    unless @school.present?
      flash[:error] = "School not found"
      redirect_to root_path and return
    end 
  end

  def validate_school_admin
    return if current_user.school_admin? && current_user.school == @school
    flash[:error] = "You are not authorized to update this school"
    redirect_to root_path and return
  end
end
