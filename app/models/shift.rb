class Shift < ApplicationRecord
  belongs_to :assignment
  has_one :employee, through: :assignment
  has_one :store, through: :assignment
  has_many  :shift_jobs
  has_many :jobs, through: :shift_jobs
  
  
  validates :status, inclusion:{ in:['pending','started','finished'] , message: 'is not an option'}
  validates_presence_of :assignment_id, :start_time, :status
  validates_date :date, on_or_after: -> {:start},on_or_before_message: "Shifts date must be on or before assginmetn date"
  validates_time :start_time
  validates_time :end_time, after: :start_time, allow_blank: true
  validate :must_curr_assignment
  
  scope :for_employee,  -> (employee_id) {joins(:assignment, :employee).where("assignments.employee_id = ?", employee_id)}
  scope :for_store,     ->    (store_id){joins(:assignment, :store).where("assignments.store_id = ?", store_id)}
  scope :past,          ->              {where("date < ?",Date.current)}
  scope :upcoming,      ->              {where("date >= ?",Date.current)}
  scope :pending,       ->              {where("status = ?",'pending')}
  scope :started,       ->              {where("status = ?",'started')}
  scope :finished,      ->              {where("status = ?",'finished')}
  scope :chronological, ->              {order('date,start_time')}
  scope :by_store,      ->              {joins(:store).order('name')}
  scope :by_employee,   ->              {joins(:employee).order('last_name, first_name')}
  scope :completed,     ->  {joins(:shift_jobs).group(:shift_id)}
  scope :incomplete,    ->  {joins('left join shift_jobs on shifts.id = shift_jobs.shift_id').where('Shift_jobs.job_id is NULL')}
  
  scope :for_next_days, ->          (x){ where('date <= ? AND date >= ?', x.days.from_now, Date.current)}
  scope :for_past_days, ->          (x){ where('date >= ? AND date <  ?', x.days.ago.to_date, Date.current)}
  scope :for_dates,     ->          (x){ where('date >= ? AND date <= ?', x.start_date, x.end_date)}
  
  def report_completed?
      if shift_jobs.count> 0
          return true
      else
         return false
      end
  end
  
  def duration
      time = end_time-start_time
      durr = (time/3600).round
      durr
  end
  

# =>CallBacks
    before_create :set_end_time
    
    before_destroy :destroy?
    
    private
    
        def start
            @start = assignment.start_date.to_date
        end
    
        def destroy?
            if (status == "started" || status == "finished")
                throw(:abort)
            end
            return true
        end
    
        def must_curr_assignment
            unless self.assignment.nil? || self.assignment.end_date.nil?
            errors.add(:assignment_id,"no current assignment for this id")
        end
    
        def set_end_time
            unless end_time.present?
            end_time = start_time + (3*60*60)
            return end_time
        end
    

end
end
end