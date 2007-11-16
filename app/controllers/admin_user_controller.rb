class AdminUserController < ApplicationController
  include AdminAuthenticatedSystem
  before_filter :login_required
  layout 'admin'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_pages, @users = paginate :users, :per_page => 10
    @users.sort! {|u1, u2| u1.realname<=>u2.realname}
  end

  def new
    @user = User.new
    @roles = User.role_list
  end

  def create
    @user = User.new(params[:user])
    @user.realname = @user.login if @user.realname == ""
    @user.password = @user.login if @user.password == ""
    @user.password_confirmation = @user.login if @user.password_confirmation == ""
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to admin_user_url(:action => 'list')
    else
      @roles = User.role_list
      @user.password = ""
      @user.password_confirmation = ""
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @roles = User.role_list
  end

  def update
    @user = User.find(params[:id])
    @user.realname = @user.login if @user.realname == ""
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to admin_user_url(:action => 'list', :id => @user)
    else
      @roles = User.role_list
      @user.password = ""
      @user.password_confirmation = ""
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_user_url(:action => 'list')
  end
end
