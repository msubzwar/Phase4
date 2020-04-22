class PayGradeRate < ApplicationRecord
    belongs_to :pay_grade
    validates :rate, numericality:  {  greater_than: 0}
        
    scope :current,         ->              {where('end_date IS NULL')}
    scope :chronological,   ->              {order('start_date')}
    scope :for_date,        ->        (date){where('start_date <= ?',date.to_date)}
    scope :for_pay_grade,   ->   (pay_grade){where('pay_grade_id = ?',pay_grade.id)}
# => Callbacks
    before_destroy :destroy?
    
    private
    def destroy?
        throw(:abort)
    end
    
end

