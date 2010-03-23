class TagsController < ApplicationController
  def search
    @topics = Topic.find_tagged_with(params[:tag_name]).paginate :page => current_page
    @forum = Forum.first
    render 'forums/show'
  end
end