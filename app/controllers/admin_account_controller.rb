class AdminAccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AdminAuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  layout 'admin'

  # say something nice, you goof!  something sweet.
  def index
    flash.keep    
    redirect_to(:action => 'signup') unless logged_in? || Administrator.count > 0
    redirect_to(:action => 'login') unless logged_in? || Administrator.count <= 0
    redirect_to(admin_speech_url(:controller => 'admin_speech', :action => 'list')) if logged_in?   
  end

  def login
    return unless request.post?
    self.current_administrator = Administrator.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_administrator.remember_me
        cookies[:auth_token] = { :value => self.current_administrator.remember_token , :expires => self.current_administrator.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/admin_account', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    redirect_to(:action => 'login') unless logged_in? || Administrator.count <= 0  
    @administrator = Administrator.new(params[:administrator])
    return unless request.post?
    @administrator.save!
    self.current_administrator = @administrator
    redirect_back_or_default(:controller => '/admin_account', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_administrator.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/admin_account', :action => 'index')
  end
end
