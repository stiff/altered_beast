class ForumsController < ApplicationController
  before_filter :admin_required, :except => [:index, :show, :show_all, :hide_downvoted]

  # GET /forums
  # GET /forums.xml
  def index
    # reset the page of each forum we have visited when we go back to index
    session[:forums_page] = nil

    @forums = current_site.ordered_forums

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forum = Forum.find_by_permalink(params[:id])
    (session[:forums] ||= {})[@forum.id] = Time.now.utc
    (session[:forums_page] ||= Hash.new(1))[@forum.id] = current_page if current_page > 1

    session[:show_all] ||= false

    respond_to do |format|
      format.html do # show.html.erb

        if session[:show_all] == true
          @topics = Topic.paginate_by_forum_id @forum.id,
                    :page => current_page,
                    :order => "sticky desc, last_updated_at desc"
                    #, :order => "score DESC"
        else
          # @topics = Topic.paginate_by_forum_id @forum.id, :page => current_page, :order => "score DESC", :conditions => "score > 0"
          @topics = Topic.paginate_by_forum_id @forum.id,
                    :page => current_page,
                    :order => "sticky desc, last_updated_at desc",
                    :conditions => "score > 0"
        end
      end
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum = Forum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    @forum = current_site.forums.find_by_permalink(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = current_site.forums.build(params[:forum])

    respond_to do |format|
      if @forum.save
        flash[:notice] = I18n.t 'txt.forum_created', :default => 'Forum was successfully created.'
        format.html { redirect_to(@forum) }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forum = current_site.forums.find_by_permalink(params[:id])

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        flash[:notice] = I18n.t 'txt.forum_updated', :default => 'Forum was successfully updated.'
        format.html { redirect_to(@forum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = current_site.forums.find_by_permalink(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_path) }
      format.xml  { head :ok }
    end
  end

  def show_all
    session[:show_all] = true
    redirect_to root_path
  end

  def hide_downvoted
    session[:show_all] = false
    redirect_to root_path
  end

end
