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
    password_authentication params[:login].downcase, params[:password], false
  end

  private
  def set_language
    I18n.locale = :en || I18n.default_locale
  end

end
