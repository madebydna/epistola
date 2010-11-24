class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @conversations = @group.messages.threads.paginate(:page => params[:page])
  end

end
