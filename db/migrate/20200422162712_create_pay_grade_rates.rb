class CreatePayGradeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :pay_grade_rates do |t|
      t.float :rate
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
