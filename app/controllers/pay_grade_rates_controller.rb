class PayGradeRatesController < ApplicationController
    
  before_action :set_pay_grade_rate, only: [:show, :edit, :update]
  def index
      @current_rate = PayGradeRate.current.chronological.paginate(page: params[:page]).per_page(10)
  end

  def show
      
  end
  
  def new
    @pay_grade_rate = PayGradeRate.new
  end

  def edit
  end

  def create
    @pay_grade_rate = PayGradeRate.new(store_params)
    if @pay_grade_rate.save
      redirect_to @pay_grade_rate, notice: "Successfully added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @pay_grade_rate.update_attributes(store_params)
      redirect_to @pay_grade_rate, notice: "Updated Pay Grade Rate information ."
    else
      render action: 'edit'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pay_grade_rate
    @pay_grade_rate = PayGradeRate.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_params
    params.require(:pay_grade_rate).permit(:rate, :start_date,)
  end
end
