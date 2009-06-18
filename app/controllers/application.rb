# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	before_filter :instantiate_controller_and_action_names
	
	def instantiate_controller_and_action_names
	      @current_action = action_name
	      @current_controller = controller_name
	end 
    
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_xidaotech_com_seminarManagementSystem_session_id'
end
