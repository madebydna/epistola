class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end


  def show
    @group = Group.find(params[:id])
    redirect_to group_conversations_path(@group)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end


  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(group_conversations_path(@group), :notice => 'Group was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(group_conversations_path(@group), :notice => 'Group was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to(groups_url)
  end
end
