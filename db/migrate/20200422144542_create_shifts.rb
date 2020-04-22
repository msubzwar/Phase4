class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.references :assignment, foreign_key: true
      t.date :date
      t.time :start_time
      t.time :end_time
      t.text :notes
      t.string :status

      t.timestamps
    end
  end
end
