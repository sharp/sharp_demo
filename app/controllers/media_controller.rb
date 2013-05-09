class MediaController < ApplicationController

  respond_to :html, :js

  set_tab :media, :site_nav

  def index
    if params[:column_id]
      @media = Medium.share.includes(:user, :column).where(column_id: params[:column_id]).order('downloads_count desc').page(params[:page])
    else
      @media = Medium.share.includes(:user, :column).order('downloads_count desc').page(params[:page])
    end
    set_tab :index, :media_nav
  end

  def hot
    @media = Medium.share.includes(:user, :column).order('readings_count desc').page params[:page]
    set_tab :hot, :media_nav  
    render 'media/index'
  end

  def latest
    @media = Medium.share.includes(:user, :column).order('created_at desc').page params[:page]
    set_tab :latest, :media_nav  
    render 'media/index'
  end

  def top
    @top_users = User.order('media_value desc').page(params[:page]).per(28) 
    set_tab :top, :media_nav
  end

  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy
  end
end
