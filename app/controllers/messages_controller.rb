class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  before_filter :authenticate_service, :only => [:create]
  
  def index
    @group = Group.find params[:group_id]
    # message will be the last in the thread
    @message = @group.messages.find(params[:thread]).root
    @messages = @message.subtree.paginate(:page => params[:page], :per_page => 20, 
                                          :order => "created_at ASC")
  end
  
  def show
    # permalink to message
    @message = Message.find(params[:id])
  end

  def create
    respond_to do |format|
      format.json do
        @group = Group.find_or_create_by_name(params[:message].delete(:group))
        @message = @group.messages.create(params[:message])
        render :json => @message.to_json        
      end
    end
  end

protected 
  
  def authenticate_service
    authenticate_or_request_with_http_basic do |id, password| 
      id == "andrea" && password == "secret"
    end
  end

end
