class SpeechController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
  def index
    self.next
  end

  def list
    @speech_pages, @speeches = paginate :speeches, :per_page => 10,  :order=>"date", :conditions=>["date >= :current_date", {:current_date=>Time.now.yesterday}]
  end

  def show
    @speech = Speech.find(params[:id])
    @posts = @speech.forum_posts.find(:all,:order => 'root_id desc, lft')
    if(flash[:post] == nil)
      @post = ForumPost.new(:speech_id=>params[:id])
    else
      @post = flash[:post];
    end
    judge_is_my_speech
  end
  
  def next
    @speech = Speech.find(:first, :order=>'date', :conditions=>["date >= :current_date", {:current_date=>Time.now.yesterday}])
    if(@speech == nil)
      render :action=>'no_next'
    else
      @posts = @speech.forum_posts.find(:all,:order => 'root_id desc, lft')
      @post = ForumPost.new(:speech_id=>@speech.id)
      judge_is_my_speech
      render :action => 'show'
    end
  end
  
  def history_list
    @speech_pages, @speeches = paginate :speeches, :per_page => 10, :order=>"date desc", :conditions=>["date < :current_date", {:current_date=>Time.now.yesterday}]
    render :action => 'list'
  end
  
  def judge_is_my_speech
    if(@speech.speaker_id == current_user.id)
      @is_editable_speech = true
    end
  end
  
end
