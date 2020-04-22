require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # Matchers
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)
  should have_many(:shifts).through(:assignments)
  should have_many(:pay_grades).through(:assignments)
  should have_many(:pay_grade_rates).through(:pay_grades)
  should have_secure_password

  # Test basic validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:ssn)
  should validate_presence_of(:role)
  should validate_presence_of(:username)
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should_not allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  # tests for ssn
  should allow_value("123456789").for(:ssn)
  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("1234567890").for(:ssn)
  should_not allow_value("bad").for(:ssn)
  should_not allow_value(nil).for(:ssn)
  # test date_of_birth
  should allow_value(17.years.ago.to_date).for(:date_of_birth)
  should allow_value(15.years.ago.to_date).for(:date_of_birth)
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(13.years.ago).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(nil).for(:date_of_birth)
  # tests for role
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("employee").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("vp").for(:role)
  should_not allow_value(nil).for(:role)
  
  # Context
  context "Given context" do
    setup do 
      create_employees
    end
    
    teardown do
      # destroy_employees
    end

    # a manual test employees must have unique ssn (could have used a matcher...)
    should "force employees to have unique ssn" do
      repeat_ssn = FactoryBot.build(:employee, first_name: "Steve", last_name: "Crawford", ssn: "084359822")
      deny repeat_ssn.valid?
    end

    # test the scope 'active'
    should "have all active employees accounted for" do
      assert_equal 6, Employee.active.size 
      deny Employee.active.include?(@chuck)
      assert_equal [@alex,@ben,@cindy,@ed,@kathryn,@ralph], Employee.active.sort_by{|emp| emp.first_name}
    end

    # test the scope 'inactive'
    should "have all inactive employees accounted for" do
      assert_equal 1, Employee.inactive.size 
      deny Employee.inactive.include?(@ralph)
      assert_equal [@chuck], Employee.inactive
    end

    # test 'make_active' method
    should "have a make_active method" do
      deny @chuck.active
      @chuck.make_active
      @chuck.reload
      assert @chuck.active
    end

    # test 'make_inactive' method
    should "have a make_inactive method" do
      assert @ralph.active
      @ralph.make_inactive
      @ralph.reload
      deny @ralph.active
    end

    # test scope alphabetical
     should "list employees alphabetically" do
      assert_equal ["Crawford", "Gruberman", "Heimann", "Janeway", "Sisko", "Waldo", "Wilson"], Employee.alphabetical.map{|e| e.last_name}
    end   

    # test scope younger_than_18
    should "show there are two employees under 18" do
      assert_equal 2, Employee.younger_than_18.size
      assert_equal ["Crawford", "Wilson"], Employee.younger_than_18.map{|e| e.last_name}.sort
    end
    
    # test scope is_18_or_older
    should "show there are four employees over 18" do
      assert_equal 5, Employee.is_18_or_older.size
      assert_equal ["Gruberman", "Heimann", "Janeway", "Sisko", "Waldo"], Employee.is_18_or_older.alphabetical.map{|e| e.last_name}.sort
    end

    # test the scope 'regulars'
    should "shows that there are 4 regular employees: Ed, Cindy, Chuck and Ralph" do
      assert_equal 4, Employee.regulars.size
      assert_equal ["Crawford","Gruberman","Waldo","Wilson"], Employee.regulars.map{|e| e.last_name}.sort
    end
    
    # test the scope 'managers'
    should "shows that there are 2 managers: Ben and Kathryn" do
      assert_equal 2, Employee.managers.size
      assert_equal ["Janeway", "Sisko"], Employee.managers.map{|e| e.last_name}.sort
    end
    
    # test the scope 'admins'
    should "shows that there is one admin: Alex" do
      assert_equal 1, Employee.admins.size
      assert_equal [@alex], Employee.admins
    end

    # test the method 'name'
    should "shows name as last, first name" do
      assert_equal "Heimann, Alex", @alex.name
    end   
    
    # test the method 'proper_name'
    should "shows proper name as first and last name" do
      assert_equal "Alex Heimann", @alex.proper_name
    end 

    # test the callback is working 'reformat_ssn'
    should "shows that Cindy's ssn is stripped of non-digits" do
      assert_equal "084359822", @cindy.ssn
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Ben's phone is stripped of non-digits" do
      assert_equal "4122682323", @ben.phone
    end

    # test the method 'over_18?'
    should "shows that over_18? boolean method works" do
      assert @ed.over_18?
      deny @cindy.over_18?
    end
    
    # test the method 'age'
    should "shows that age method returns the correct value" do
      assert_equal 19, @ed.age
      assert_equal 17, @cindy.age
      assert_equal 30, @kathryn.age
    end

    # test the method 'current_assignment'
    should "shows return employee's current assignment, if it exists" do
      create_stores
      create_pay_grades
      create_assignments
      assert_equal @assign_kathryn, @kathryn.current_assignment
      assert_nil @alex.current_assignment
      destroy_assignments
      destroy_pay_grades
      destroy_stores
    end

# test the method 'current_pay_grade'
  should "shows return employee's current pay grade as a string, if it exists" do
    create_stores
    create_pay_grades
    create_assignments
    assert_equal "M1", @kathryn.current_pay_grade
    assert_nil @alex.current_pay_grade
    destroy_assignments
    destroy_pay_grades
    destroy_stores
  end

  # test the method 'current_pay_rate'
  should "shows return employee's current pay rate as a float, if it exists" do
    create_stores
    create_pay_grades
    create_pay_grade_rates
    create_assignments
    assert_equal 20.75, @kathryn.current_pay_rate
    assert_nil @alex.current_pay_grade
    destroy_assignments
    destroy_pay_grade_rates
    destroy_pay_grades
    destroy_stores
  end

should "allow employees who have yet to work a shift to be destroyed" do
     create_stores
     create_pay_grades
     create_pay_grade_rates
     create_assignments
     create_shifts
     deny @cindy.shifts.upcoming.empty?
     assert @cindy.shifts.past.empty?
     current_assignment_id = @cindy.current_assignment.id
     current_shifts_ids = @cindy.shifts.map(&:id)
     assert @cindy.destroy
     assert_raise ActiveRecord::RecordNotFound do Assignment.find(current_assignment_id); end
     current_shifts_ids.each do |shift_id|
       assert_raise ActiveRecord::RecordNotFound do Shift.find(shift_id); end
     end
   end

   should "not allow employees who have worked a shift to be destroyed" do
     create_stores
     create_pay_grades
     create_pay_grade_rates
     create_assignments
     create_shifts
     assert @ralph.active
     deny @ralph.shifts.finished.empty?
     deny @ralph.shifts.pending.empty?
     deny @ralph.destroy
     @ralph.reload
     deny @ralph.active
     assert @ralph.shifts.pending.empty?
     deny @ralph.shifts.finished.empty?
     assert_nil @ralph.current_assignment
   end

   should "not allow an improper edit of employee to kick in deletion protocols" do
     create_stores
     create_pay_grades
     create_pay_grade_rates
     create_assignments
     create_shifts
     # preconditions
     assert @ralph.active
     deny @ralph.shifts.pending.empty?
     refute_nil @ralph.current_assignment
     # bad edit that will force a rollback
     @ralph.first_name = nil
     @ralph.save
     @ralph.reload
     # postcondition: still has an active status, current assignment and pending shifts
     assert @ralph.active
     deny @ralph.shifts.pending.empty?
     refute_nil @ralph.current_assignment
   end

  end
end
