class AddPayGradeToPayGradeRate < ActiveRecord::Migration[5.2]
  def change
    add_reference :pay_grade_rates, :pay_grade, foreign_key: true
  end
end
