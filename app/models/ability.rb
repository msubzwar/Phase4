# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
  
    user ||= Employee.new # guest user (not logged in)
    
      if user.role? :admin
        can :manage, :all
      elsif user.role? :manager
        can :index, Employee
        can :show,  Employee do |e|
           user.current_assignment.store.id == e.current_assignment.store.id
        end
        can :edit,  Employee do |e|
           user.current_assignment.store.id == e.current_assignment.store.id
        end
        can :update,  Employee do |e|
           user.current_assignment.store.id == e.current_assignment.store.id
        end
        can :index, Assignment
        
        can :show, Assignment do |a|
            all_assignment = Assignment.current.for_store(user.current_assignment.store).map{|a| a.id}
            all_assignment.include?(a.id)
        end 
        
        can :manage,    ShiftJob
        can :manage,    Shift
        # can :new,       Shift 
        # can :edit,      Shift
        # can :destroy,   Shift
        # can :show,      Shift
        can :index,     Job
        can :show,      Job
        can :new,       Job
        
        
      elsif user.role? :employee
        can :index, Assignment
        
        can :show,  Employee do |e|
           user.id == e.id
        end
        can :show, Assignment do |a|
            user.id== a.employee.id
        end
        can :edit, Employee do |a|
            user.id== a.id
        end
        can :update, Employee do |a|
            user.id== a.id
        end
    
    end
end
end
