class AddShiftToShiftJob < ActiveRecord::Migration[5.2]
  def change
    add_reference :shift_jobs, :shift, foreign_key: true
  end
end
