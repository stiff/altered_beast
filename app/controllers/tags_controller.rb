module TagForum
  def contain_posts?
    false
  end
  attr_accessor :name, :topics
end

class TagsController < ApplicationController
  def search
    @topics = Topic.find_tagged_with(params[:tag_name]).paginate :page => current_page
    @forum = Forum.first
    @forum.extend TagForum

    @forum.topics = @topics
    @forum.name = "##{params[:tag_name]}"
    def @forum.contain_posts?
      false
    end

    render 'forums/show'
  end
end