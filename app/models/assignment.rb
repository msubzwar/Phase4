class Assignment < ApplicationRecord

  # Relationships
  belongs_to :store
  belongs_to :employee
  has_many :shifts
  belongs_to :pay_grade

  # Scopes
  scope :current,       -> { where('end_date IS NULL') }
  scope :past,          -> { where('end_date IS NOT NULL') }
  scope :by_store,      -> { joins(:store).order('name') }
  scope :by_employee,   -> { joins(:employee).order('last_name, first_name') }
  scope :chronological, -> { order('start_date DESC, end_date DESC') }
  scope :for_store,     ->(store) { where("store_id = ?", store.id) }
  scope :for_employee,  ->(employee) { where("employee_id = ?", employee.id) }
  scope :for_role,      ->(role) { joins(:employee).where("role = ?", role) }
  scope :for_date,      ->(date) { where("start_date <= ? AND (end_date > ? OR end_date IS NULL)", date, date) }
  scope :for_pay_grade, ->(pay_grade){ joins(:pay_grade).where("pay_grade_id = ? ", pay_grade.id)}

  # Validations
  validates_presence_of :store_id, :employee_id, :start_date,:pay_grade_id
  validates_date :start_date, on_or_before: ->{ Date.current }, on_or_before_message: "cannot be in the future"
  validates_date :end_date, after: :start_date, on_or_before: ->{ Date.current }, allow_blank: true
  validate :employee_is_active_in_system
  validate :store_is_active_in_system

  # Other methods
  def terminate
    return false unless self.end_date.nil?
    self.start_date = Date.current
    end_previous_assignment
    self.reload
  end


  # Callbacks
  before_create :end_previous_assignment
#   before_destroy :rem_shifts
  before_destroy :rem_prev_shifts
  # before_create :set_start_date_if_not_set

  private
  def end_previous_assignment
    current_assignment = Employee.find(self.employee_id).current_assignment
    if current_assignment.nil?
      return true
    else
      current_assignment.update_attribute(:end_date, self.start_date.to_date)
    end
  end


    def rem_prev_shifts
        shift = Shift.all
        shift.each do |s|
            if (s.status == 'pending')
                s.delete
                self.save!
            end
            
        end
    end
    
    

  def employee_is_active_in_system
    all_employee_ids = Employee.active.map(&:id)
    unless all_employee_ids.include?(self.employee_id)
      errors.add(:employee, "is not an active employee in the system")
    end
  end

  def store_is_active_in_system
    all_store_ids = Store.active.map(&:id)
    unless all_store_ids.include?(self.store_id)
      errors.add(:store, "is not an active store in the system")
    end
  end

  # def set_start_date_if_not_set
  #   return true unless self.start_date.nil?
  #   self.start_date = Date.current
  # end

end
