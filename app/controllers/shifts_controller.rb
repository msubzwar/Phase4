class ShiftsController < ApplicationController
    load_and_authorize_resource
    before_action :set_shift, only: [:show, :edit, :update, :destroy]
  def index
    #   if current_user && current_user.role?(:admin)
    @shifts = Shift.all.paginate(page: params[:page]).per_page(10)
    @upcoming_shifts = Shift.upcoming.by_employee.paginate(page: params[:page]).per_page(10)

  end

  def show
  end

  def new
      @shift = Shift.new
  end

  def edit
  end
    def update
    if @shift.update(shift_params)
      redirect_to shift_path(@shift), notice: "Successfully updated #{@shift.employee.name}'s shift."
    else
      render action: 'edit'
    end
  end

  private
  def set_shift
      @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:date, :assignment_id, :start_time, :end_time, :notes, :job_ids => [])
  end


end
