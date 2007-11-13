class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  layout 'speech'

  # say something nice, you goof!  something sweet.
  def index
    flash.keep
    #redirect_to(:action => 'signup') unless logged_in? || User.count > 0
    redirect_to(:action => 'login') unless logged_in?
    redirect_to(:controller => 'speaker', :action => 'list') if logged_in?      
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
#    @user = User.new(params[:user])
#    return unless request.post?
#    @user.save!
#    self.current_user = @user
#    redirect_back_or_default(:controller => '/account', :action => 'index')
#    flash[:notice] = "Thanks for signing up!"
#  rescue ActiveRecord::RecordInvalid
#    render :action => 'signup'
    redirect_to(:action => 'login') 
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
  
  before_filter :login_required, :only=>[:show, :edit, :update]
  
  def edit
    @user = current_user
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  verify :method => :post, :only => [ :update ],
         :redirect_to => { :action => :index }

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      @user.password = '';
      @user.password_confirmation = '';
      render :action => 'edit'
    else
      @user.password = '';
      @user.password_confirmation = '';
      @roles = User.role_list
      render :action => 'edit'
    end
  end
end
