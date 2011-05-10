class MonitorshipsSweeper < ActionController::Caching::Sweeper
  observe Monitorship

  def after_save(monitorship)
    FileUtils.rm_rf Rails.root.join('public', 'users', monitorship.user_id.to_s)
  end

  alias_method :after_destroy, :after_save
end
