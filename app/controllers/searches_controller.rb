class SearchesController < ApplicationController
  
  def index
    @query = params[:search][:q]
    if params[:commit] =~ /All/
      params[:search].delete(:group_id)
    else
      @group = Group.find(params[:search][:group_id]) if params[:search][:group_id]
    end
    @results = Message.do_search(params[:search], params[:page])
  end
  
end