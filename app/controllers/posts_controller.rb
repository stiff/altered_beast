class PostsController < SessionsController
  before_filter :find_parents
  before_filter :find_post, :only => [:edit, :update, :destroy]
  prepend_before_filter :login_filter, :only => :create
  before_filter :validate_user, :only => [:create, :destroy]
  # /posts
  # /users/1/posts
  # /forums/1/posts
  # /forums/1/topics/1/posts
  def index
    @posts = (@parent ? @parent.posts : current_site.posts).search(params[:q], :page => current_page)
    @users = @user ? {@user.id => @user} : User.index_from(@posts)
    respond_to do |format|
      format.html # index.html.erb
      format.atom # index.atom.builder
      format.xml  { render :xml  => @posts }
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to forum_topic_path(@forum, @topic) }
      format.xml  do
        find_post
        render :xml  => @post
      end
    end
  end

  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end
  end

  def create
    if logged_in?
      @post = current_user.reply @topic, params[:post][:body]
    else
      @post = Post.new
    end
    respond_to do |format|
      if @post.new_record?
        format.html { redirect_to forum_topic_path(@forum, @topic) }
        format.xml  { render :xml  => @post.errors, :status => :unprocessable_entity }
      else
        flash[:notice] = I18n.t 'txt.post_created', :default => 'Post was successfully created.'
        format.html { redirect_to(forum_topic_post_path(@forum, @topic, @post, :anchor => dom_id(@post))) }
        format.xml  { render :xml  => @post, :status => :created, :location => forum_topic_post_url(@forum, @topic, @post) }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = I18n.t 'txt.post_updated', :default => 'Post was successfully updated.'
        format.html { redirect_to(forum_topic_path(@forum, @topic, :anchor => dom_id(@post))) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(forum_topic_path(@forum, @topic)) }
      format.xml  { head :ok }
    end
  end

protected
  def find_parents
    if params[:user_id]
      @parent = @user = User.find(params[:user_id])
    else
      @parent = @forum = Forum.first
      @parent = @topic = @forum.topics.find_by_permalink(params[:topic_id]) if params[:topic_id]
    end
  end

  def find_post
    post = @topic.posts.find(params[:id])
    if post.user == current_user || current_user.admin?
      @post = post
    else
      raise ActiveRecord::RecordNotFound
    end
  end

private
  def validate_user
    unless can_comment?
      flash[:error] = I18n.t 'txt.messages_until_activate',
        :default => "You can not post more than 5 messages until you activate your account. Please click the link in your email to activate your account"
      redirect_back_or_default(forum_topic_path(@forum, @topic))
    end
  end

end
