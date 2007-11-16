class AdminSpeechController < ApplicationController
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
    @speech_pages, @speeches = paginate :speeches, :order => 'date', :per_page => 10
  end
  
  def _get_user_select
    return (User.find_all_by_role(User.role_for_speaker).sort_by {|u| Iconv.conv("GBK", "UTF-8", u.realname)}).map {|u| [u.realname,u.id]}
  end

  def new
    @speech = Speech.new
    @speech_types = Speech.speech_types
    @users = self._get_user_select#User.find_all_by_role(User.role_for_speaker).map {|u| [u.realname,u.id]}
    if (@users.length==0)
      render :action=>'no_speaker'
    end
  end

  def create
    @speech = Speech.new(params[:speech])
    @speech.speaker_name = @speech.speaker.realname;
    if @speech.save
      flash[:notice] = 'Speech was successfully created.'
      redirect_to admin_speech_url(:action => 'list')
    else
      @speech_types = Speech.speech_types
      @users =self._get_user_select
      render :action => 'new'
    end
  end

  def edit
    @speech = Speech.find(params[:id])
    @speech_types = Speech.speech_types
    @users = self._get_user_select#User.find_all_by_role(User.role_for_speaker).map {|u| [u.realname,u.id]}
    if (@users.length==0)
      render :action=>'no_speaker'
    end
  end

  def update
    @speech = Speech.find(params[:id])
    @user = User.find(params[:speech]["speaker_id"])
    @speech.speaker_name = @user.realname;
    if @speech.update_attributes(params[:speech])
      flash[:notice] = 'Speech was successfully updated.'
      redirect_to admin_speech_url(:action => 'list', :id => @speech)
    else
      @speech_types = Speech.speech_types
      @users = self._get_user_select#User.find_all_by_role(User.role_for_speaker).map {|u| [u.realname,u.id]}
      render :action => 'edit'
    end
  end

  def destroy
    Speech.find(params[:id]).destroy
    redirect_to admin_speech_url(:action => 'list')
  end
end
