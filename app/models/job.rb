class Job < ApplicationRecord
    has_many :shift_jobs
    has_many :shifts, through: :shift_jobs
    
    validates_presence_of :name
    
    scope :active,      ->  {where(active: true)}
    scope :inactive,    ->  {where(active: false)}
    scope :alphabetical,->  {order("name")}
    
    def make_active
        self.active=true
        self.save!
    end
    
    def make_inactive
        self.active = false
        self.save!
    end
    before_destroy :destroy?
    private
    
    def destroy?
        return nil unless (shift_jobs.present?)
        throw(:abort)
    end

    
end
