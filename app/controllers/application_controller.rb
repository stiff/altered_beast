# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  include PathHelper

  helper :all
  helper_method :current_page,:can_comment?
#  before_filter :set_language
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e125a4be589f9d81263920581f6e4182'

  # Filter password parameter from logs
  filter_parameter_logging :password

  # raised in #current_site
  rescue_from Site::UndefinedError do |e|
    redirect_to new_site_path
  end

  def can_comment?
    !logged_in? || current_user.active?
  end

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

  protected


  def login_filter
    if !logged_in?
        unless params["user"]["password_confirmation"].nil? || params["user"]["password_confirmation"].empty?
          user = create_user false
          password_authentication( user.login.downcase, user.password, false ) unless user.new_record?
        else
          password_authentication( params[:login].downcase, params[:password], false )
        end
    end
  end
  #mapa
  def create_user(should_redirect = true)
    cookies.delete :auth_token
    @user = current_site.users.build(params[:user])
    @user.save if @user.valid?
    @user.register! if @user.valid?
    unless @user.new_record?
      redirect_back_or_default(login_path) if should_redirect
      flash[:notice] = I18n.t 'txt.activation_required',
        :default => "Thanks for signing up! Please click the link in your email to activate your account"
    else
      flash[:error] = @user.errors.full_messages.uniq.join(" / ")
      if should_redirect
        render :action => "new", :controller => "users"
      end
    end
    @user
  end

  private
  def set_language
    I18n.locale = :en || I18n.default_locale
  end

end
