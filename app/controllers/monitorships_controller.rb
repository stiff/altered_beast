class MonitorshipsController < ApplicationController
  before_filter :login_required

  def update
    topic = Topic.find_by_permalink(params[:id])
    update_monitorship(current_user, topic, params.has_key?(:enable_monitor))
    respond_to do |format|
      format.html { redirect_to topic_path(params[:id]) }
    end
  end

end
