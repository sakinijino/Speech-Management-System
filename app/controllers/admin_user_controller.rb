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
  end

  def new
    @user = User.new
    @roles = User.role_list
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to admin_user_url(:action => 'list')
    else
      @roles = User.role_list
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @roles = User.role_list
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to admin_user_url(:action => 'list', :id => @user)
    else
      @roles = User.role_list
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_user_url(:action => 'list')
  end
end
