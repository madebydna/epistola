# encoding: utf-8
class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  before_filter :authenticate_service, :only => [:create]
  before_filter :force_utf8_params, :only => [:create]
  
  def index
    @group = Group.find params[:group_id]
    @message = @group.messages.find params[:thread]
    unless @message.is_root?
      redirect_to group_message_path(@group, @message) # redirect to permalink
    end
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
  
  
  def force_utf8_params
    traverse = lambda do |object, block|
      if object.kind_of?(Hash)
        object.each_value { |o| traverse.call(o, block) }
      elsif object.kind_of?(Array)
        object.each { |o| traverse.call(o, block) }
      else
        block.call(object)
      end
      object
    end
    force_encoding = lambda do |o|
      o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
    end
    traverse.call(params, force_encoding)
  end
  

end
