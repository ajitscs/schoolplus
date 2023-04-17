class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :initialize_school
  before_action :initialize_course, only: [:show, :update, :edit, :destroy]
  before_action :validate_school_admin, only: [:edit, :update, :show]
  

  def index
    @courses = @school.courses.all.order(id: :desc)#.paginate(page: params[:page])
  end

  def new
    @course = @school.courses.new
  end

  def create
    @course = @school.courses.new(course_params)
    if @course.save
      flash[:success] = "courses has been created successfully"
      redirect_to school_courses_path(school_id: @school.id)
    else
      flash[:error] = @course.errors.full_messages.join("<br>").html_safe
      render action: :new
    end
  end

  def edit
  end

  def update
    @course.assign_attributes(course_params)
    if @course.save
      flash[:success] = "course has been update successfully"
      redirect_to school_courses_path(school_id: @school.id)
    else
      flash[:error] = @course.errors.full_messages.join("<br>").html_safe
      render action: :edit
    end
  end

  def destroy
    if @course.destroy
      flash[:notice] = "course has been deleted successfully"
    else
      flash[:error] = @course.errors.full_messages.join("<br>").html_safe
    end
    redirect_to school_courses_path(school_id: @school.id)
  end

  private

  def course_params
    params[:course][:user_id] = current_user.id
    params.require(:course).permit(:title, :duration, :school_id, :user_id)
  end

  def initialize_course
    @course = @school.courses.find_by(id: params[:id])
    unless @course.present?
      flash[:error] = "courses not found"
      redirect_to root_path and return
    end 
  end

  def initialize_school
    @school = current_user.school
  end

  def validate_school_admin
    return if current_user.school_admin? && current_user.school == @school
    flash[:error] = "You are not authorized to update this courses"
    redirect_to root_path and return
  end
end
