class AddPayGradeToAssignments < ActiveRecord::Migration[5.2]
  def change
    add_reference :assignments, :pay_grade, foreign_key: true
  end
end
