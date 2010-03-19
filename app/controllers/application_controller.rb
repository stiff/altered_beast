# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all
  helper_method :current_page
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

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

  protected
  def login_filter    
    if !logged_in?
        if params["user[password_confirmation]"]    
          password_authentication params[:login].downcase, params[:password], false                      
        else
          create_user
        end
    end
  end
  
  def create_user
    cookies.delete :auth_token
    @user = current_site.users.build(params[:user])    
    @user.save if @user.valid?
    @user.register! if @user.valid?
    unless @user.new_record?
      redirect_back_or_default('/login')
      flash[:notice] = I18n.t 'txt.activation_required', 
        :default => "Thanks for signing up! Please click the link in your email to activate your account"
    else
      render :action => 'new'
    end

  end

  private
  def set_language
    I18n.locale = :en || I18n.default_locale
  end

end
