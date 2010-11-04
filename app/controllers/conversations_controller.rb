class ConversationsController < ApplicationController
  before_filter :find_group
  
  def index
    # TODO: order conversations by the date of their last message
    @conversations = @group.conversations
  end

  def show
    @conversation = @group.conversations.find(params[:id])
    @messages = @conversation.messages.
                paginate(:page => params[:page], :per_page => 20, 
                         :order => "messages.created_at ASC")
  end

  def new
    @conversation = @group.build_conversations
  end

  def edit
    @conversation = @group.conversations.find(params[:id])
  end

  def create
    @conversation = @group.build_conversations.new(params[:conversation])

    if @conversation.save
      redirect_to(group_conversation_path(@group, @conversation), :notice => 'Conversation was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @conversation = @group.conversations.find(params[:id])
    
    if @conversation.update_attributes(params[:conversation])
      redirect_to(group_conversation_path(@group, @conversation), :notice => 'Conversation was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @conversation = @group.conversations.find(params[:id])
    @conversation.destroy

    redirect_to(group_conversations_url(@group))
  end
  
private 

def find_group
  @group = Group.find params[:group_id]
end
  
end
