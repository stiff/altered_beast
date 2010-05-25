class UsersController < ApplicationController
  before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge, :edit]
  before_filter :find_user, :only => [:update, :show, :edit, :suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :only => [:settings, :update]

  # Brainbuster Captcha
  # before_filter :create_brain_buster, :only => [:new]
  # before_filter :validate_brain_buster, :only => [:create]

  def index
    users_scope = admin? ? :all_users : :users
    if params[:q]
      @users = current_site.send(users_scope).named_like(params[:q]).paginate(:page => current_page)
    else
      @users = current_site.send(users_scope).paginate(:page => current_page)
    end
  end

  # render new.rhtml
  def new
    store_location
  end

  def create
    @user = create_user
  end

  def settings
    @user = current_user
    current_site
    render :action => "edit"
  end

  def edit
    @user = find_user
  end

  def update
    @user = admin? ? find_user : current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = I18n.t 'txt.account_updated', :default => 'User account was successfully updated.'
        format.html { redirect_to(settings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activate
    # not sure why this was using a symbol. Let's use the real false.
    self.current_user = params[:activation_code].blank? ? false : current_site.all_users.find_in_state(:first, :pending, :conditions => {:activation_code => params[:activation_code]})
    if logged_in?
      current_user.activate!
      flash[:notice] = I18n.t 'txt.signup_complete', :default => "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend!
    flash[:notice] = I18n.t 'txt.user_suspended', :default => "User was suspended."
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    flash[:notice] = I18n.t 'txt.user_unsuspended', :default => "User was unsuspended."
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  def make_admin
    redirect_back_or_default('/') and return unless admin?
    @user = find_user
    @user.admin = (params[:user][:admin] == "1")
    @user.save!
    redirect_to @user
  end

  def update_state
    cities = Local.cities_of(params[:state])

    render :update do |page|
      page.replace_html 'cities_combo', :partial => 'cities', :object => cities
    end
  end
  
  def remember_password
    user = User.find_by_email params[:email]
    if user.nil?
      flash[:error] = I18n.t "txt.email_not_found", :default => "Email address not found"
      redirect_to login_path
    else
      user.generate_lost_password_secret
      user.save
      UserMailer.deliver_remember_password(user)
      flash[:notice] = I18n.t('txt.verify_your_email', :default => 'Verify your mail in order to reset your password')
      redirect_to root_url
    end
  end
  
  def reset_password
    @user = User.find_by_lost_password_secret(params[:secret])
  end
  
  def reset_password_confirmation
    @user = User.find_by_lost_password_secret(params[:user][:lost_password_secret])
    if @user.update_attributes(params[:user])
      flash[:notice] = I18n.t 'txt.account_updated', :default => 'User account was successfully updated.'
      redirect_to(login_url) 
    else
      render :action => "reset_password"
    end
  end

protected
  def find_user
    @user = if admin?
      current_site.all_users.find params[:id]
    else
      current_site.users.find params[:id]
    end or raise ActiveRecord::RecordNotFound
  end

  def authorized?
    admin? || params[:id].blank? || params[:id] == current_user.id.to_s
  end

  def render_or_redirect_for_captcha_failure
    render :action => 'new'
  end
end
