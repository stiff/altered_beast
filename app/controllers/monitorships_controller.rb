class MonitorshipsController < ApplicationController
  before_filter :login_required

  def update
    topic_id = Topic.find_by_permalink(params[:id]).id
    @monitorship = Monitorship.find_or_initialize_by_user_id_and_topic_id(current_user.id, topic_id)
    @monitorship.update_attribute :active, true
    respond_to do |format|
      format.html { redirect_to topic_path(params[:id]) }
#      format.js
    end
  end

  def destroy
    Monitorship.update_all ['active = ?', false], ['user_id = ? and topic_id = ?', current_user.id, params[:topic_id]]
    respond_to do |format|
      format.html { redirect_to topic_path(params[:forum_id], params[:topic_id]) }
#      format.js
    end
  end
end