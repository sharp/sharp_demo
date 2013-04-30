 #encoding: utf-8
require 'ostruct'
class Group::MessagesController < GroupController
  respond_to :html, :js
  set_tab :messages, :group_nav
  set_tab :sendout, :group_messages_nav, only: [:sendout]
  set_tab :index, :group_messages_nav, only: [:index]
  set_tab :write, :group_messages_nav, only: [:new]

  def index
    @messages = Message.group.where(recipient_id: current_user.id).page params[:page]
  end 

  def new
    @message = Message.new
    @group_members = [] 
    {teacher: '老师', parent: '家长', student: '学生'}.each do |role, role_name|
      group = OpenStruct.new
      group.name = role_name
      group.members = @current_group.group_members(role)
      @group_members << group
    end
  end

  def sendout
    @messages = Message.group.where(sender_id: current_user.id).page params[:page]
  end

  def show
    @message = Message.find params[:id]
    @message.update_attributes read: true
    @replies = @message.replies
    if @message.sender_id == current_user.id
      set_tab :sendout, :group_messages_nav
    else
      set_tab :index, :group_messages_nav
    end
      
    unless @message.sender_id == current_user.id or @message.recipient_id == current_user.id 
      redirect_to [:group, @current_group, 'messages']
    end
  end

  def reply
    @message = Message.new params[:message]
    @message.sender = current_user
    @message.save
  end

  def create
    recipient_ids = params[:message].delete :recipient_id
    recipient_ids.each do |recipient_id|  
      message = Message.new params[:message]
      message.sender = current_user
      message.group = @current_group
      message.recipient_id = recipient_id
      message.save
    end
    redirect_to [:group, @current_group, :messages]
  end
end