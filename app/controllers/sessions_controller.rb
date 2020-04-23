class SessionsController < ApplicationController
    def new
    
    end

    def create
      user = Employee.authenticate(params[:username], params[:password])
      if user 
        session[:employee_id] = user.id
        redirect_to home_path, notice: "Logged in!"
      else
        flash.now.alert = "Email or password is invalid"
        render "new"
      end
    end

    def destroy
      session[:employee_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
  end
