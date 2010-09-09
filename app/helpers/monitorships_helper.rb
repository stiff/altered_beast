module MonitorshipsHelper
  
  def update_monitorship(current_user, topic, state)
    get_monitorship(current_user, topic).update_attribute :active, state
  end
  
 private

  def get_monitorship(current_user, topic)
    Monitorship.find_or_initialize_by_user_id_and_topic_id(current_user.id, topic.id)
  end
  
end
