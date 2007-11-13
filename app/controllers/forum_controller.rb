class ForumController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required#,
                    #:only => [:create, :destroy]
                    
  layout 'speech'
  
  verify :method => :post, :except => [ :show ],
          :redirect_to => {:controller=>:speech, :action=>:next}

  def show
    @parent_post = ForumPost.find(params[:id])
    if(flash[:post] == nil)
      @post = ForumPost.new(:parent_id => @parent_post.id, :speech_id=>@parent_post.speech_id, :subject=>"Re:"+@parent_post.subject)
    else
      @post = flash[:post]
    end
    @posts = ForumPost.find(:all,:order => 'lft',:conditions=>["root_id = :root_id", {:root_id=>@parent_post.root_id}])
    @speech = @post.speech
    
    @has_destroy_authority = false;
    if( (logged_in?) && (@parent_post.speech.speaker_id == current_user.id || @parent_post.user == current_user) )
      @has_destroy_authority = true;
    end  
  end

  def create
    @post = ForumPost.new(params[:post])
    @post.user_name = current_user.realname
    @post.user = current_user
     
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to :action => 'show', :id => @post.id
    else
      flash[:post] = @post;
      if(@post.parent_id == nil || @post.parent_id == 0)
        redirect_to :controller=>'speech', :action=>'show', :id=>@post.speech.id, :anchor=>'errorExplanation'
      else
        redirect_to :action=>'show', :id=>@post.parent_id, :anchor=>'errorExplanation'
      end
    end
  end
  
  def destroy
    @post = ForumPost.find(params[:id])
    if( (logged_in?) && (@post.speech.speaker_id == current_user.id || @post.user == current_user) )
      speech_id = @post.speech_id
      @post.destroy
      redirect_to :controller=>'speech',:action=>'show',:id=>speech_id
    else
      redirect_to :action=>'show',:id=>@post.id
    end
  end
end

