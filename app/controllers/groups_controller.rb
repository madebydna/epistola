class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
   # @conversations = Message.ordered_threads
  end

end
