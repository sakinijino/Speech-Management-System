class SpeakerController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
  before_filter :can_create_own_speech, 
                    :only=>[:new,:create]
  before_filter :validateVisterIdentity, 
                    :only=>[:edit,:update]
  layout 'speech'
  
  def index
    list
    render :action => 'list'
  end

  verify :method => :post, :only => [ :update, :create ],
         :redirect_to => { :action => :list }

  def list
    @speeches = current_user.speeches.find(:all, :order=>"date", :conditions=>["date >= :current_date", {:current_date=>Time.now.yesterday}])
    render :action => 'list'
  end

  def edit
    @speech = Speech.find(params[:id])
  end

  def update
    @speech = Speech.find(params[:id])
    params[:speech].delete(:speaker_id);
    params[:speech].delete(:date);
    if @speech.update_attributes(params[:speech])
      flash[:notice] = 'Speech was successfully updated.'
      redirect_to :controller => 'speech', :action => 'show', :id => @speech.id
    else
      render :action => 'edit'
    end
  end
  
  def history_list
    @speeches = current_user.speeches.find(:all, :order=>"date desc", :conditions=>["date < :current_date", {:current_date=>Time.now.yesterday}])
    render :action => 'list'
  end
  
  def new
    @speech = Speech.new
  end
  
  def create
    @speech = Speech.new(params[:speech])
    @speech.speaker = current_user
    @speech.speaker_name = @speech.speaker.realname;
    if @speech.save
      flash[:notice] = 'Speech was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  private
  def validateVisterIdentity
      @speech = Speech.find(params[:id])
      if(@speech.speaker_id != current_user.id)
       flash[:notice] = 'Sorry, you cannot edit other\'s speech!'
       redirect_to :action => 'list'
       return
     end
   end
   
  def can_create_own_speech
    if (not CAN_USERS_CREATE_THEIR_OWN_SPEECHES)
      redirect_to :action => 'list'
    end
  end
   
end
