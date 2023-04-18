class StudentBatchesController < ApplicationController
  load_and_authorize_resource
  before_action :initialize_batch, except: [:classmates]
  before_action :initialize_student_batch, only: [:approve, :deny]

  def index
    @student_batches = @batch.student_batches
  end

  def create
    @student_batch = current_user.student_batches.new(batch_id: @batch.id)
    if @student_batch.save
      flash[:success] = "Enrollment request successful"
    else
      flash[:error] = @student_batch.errors.full_messages.join("<br>").html_safe
    end
    redirect_to enrol_batches_path
  end

  def approve
    @student_batch.approved!
    flash[:success] = "Enrollment request approved successfully"
    redirect_to batch_student_batches_path(batch_id: @batch.id)
  end

  def deny
    @student_batch.denied!
    flash[:success] = "Enrollment request denied successfully"
    redirect_to batch_student_batches_path(batch_id: @batch.id)
  end

  def classmates
    user_batches_ids = current_user.student_batches.approved.pluck(:batch_id).uniq
    @student_batches = StudentBatch.approved.where("batch_id in (?)", user_batches_ids)
  end

  private

  def initialize_batch
    @batch = @school.batches.where(id: params[:batch_id].to_i).first
    unless @batch.present?
      flash[:error] = "Batch not found"
      redirect_to root_path and return
    end   
  end

  def initialize_student_batch
    @student_batch = @batch.student_batches.where(id: params[:student_batch_id].to_i).first
    unless @student_batch.present?
      flash[:error] = "Enrollment request not found"
      redirect_to root_path and return
    end  
  end
end
