class ShiftJob < ApplicationRecord
    belongs_to :shift
    belongs_to :job
    
    validates_presence_of :shift_id,:job_id
    scope :alphabetical, -> { joins(:job).order('name')}
end
