class BatchesController < ApplicationController
  load_and_authorize_resource
  before_action :initialize_school
  before_action :initialize_course
  before_action :initialize_batch, only: [:show, :update, :edit, :destroy]
  before_action :validate_school_admin, only: [:edit, :update, :show]
  

  def index
    @batches = @course.batches.all.order(id: :desc)#.paginate(page: params[:page])
  end

  def new
    @batch = @course.batches.new
  end

  def create
    @batch = @course.batches.new(batch_params)
    if @batch.save
      flash[:success] = "Batch has been created successfully"
      redirect_to school_course_batches_path(school_id: @school.id, course_id: @course.id)
    else
      flash[:error] = @batch.errors.full_messages.join("<br>").html_safe
      render action: :new
    end
  end

  def edit
  end

  def update
    @batch.assign_attributes(batch_params)
    if @batch.save
      flash[:success] = "Batch has been update successfully"
      redirect_to school_course_batches_path(school_id: @school.id, course_id: @course.id)
    else
      flash[:error] = @batch.errors.full_messages.join("<br>").html_safe
      render action: :edit
    end
  end

  def destroy
    if @batch.destroy
      flash[:notice] = "Batch has been deleted successfully"
    else
      flash[:error] = @batch.errors.full_messages.join("<br>").html_safe
    end
    redirect_to school_course_batches_path(school_id: @school.id, course_id: @course.id)
  end

  private

  def batch_params
    params[:batch][:user_id] = current_user.id
    params[:batch][:school_id] = current_user.school.id
    params.require(:batch).permit(:title, :start_date, :school_id, :course_id, :user_id)
  end

  def initialize_course
    @course = @school.courses.find_by(id: params[:course_id])
    unless @course.present?
      flash[:error] = "course not found"
      redirect_to root_path and return
    end 
  end

  def initialize_school
    @school = current_user.school
  end

  def initialize_batch
    @batch = @course.batches.find_by(id: params[:id])
    unless @batch.present?
      flash[:error] = "Batch not found"
      redirect_to root_path and return
    end 
  end

  def validate_school_admin
    return if current_user.school_admin? && current_user.school == @school
    flash[:error] = "You are not authorized for this action"
    redirect_to root_path and return
  end
end
