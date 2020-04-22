class AddJobToShiftJob < ActiveRecord::Migration[5.2]
  def change
    add_reference :shift_jobs, :job, foreign_key: true
  end
end
