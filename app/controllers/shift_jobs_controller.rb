class ShiftJobsController < ApplicationController
    before_action :set_shift_job, only: [:show, :edit, :update]
  def index
    @shift_jobs = ShiftJob.all.alphabetical
  end


  def show
  end

  def edit
  end

  def new
    @shift_job = ShiftJob.new
  end
 
 private
  def set_shift_job
      @shift = Shift.find(params[:id])
  end

  def shift_job_params
    params.require(:shift_job).permit(:shift_id,:job_id)
  end


 
end
