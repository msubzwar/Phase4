class JobsController < ApplicationController

  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.all.paginate(page: params[:page]).per_page(10)
  end

  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    respond_to do |format|
      if @job.save
        @jobs = Job.all
        redirect_to @job, notice: "Successfully added #{@job.name} to the system."
      else
        render action: 'edit'
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        redirect_to @job, notice: "Successfully added #{@job.name} to the system."

      else
        render action: 'new'

      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
        redirect_to @job, notice: "Job was successfully destroyed.."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:name, :description, :active)
    end
end