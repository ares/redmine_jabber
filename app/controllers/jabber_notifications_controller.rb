class JabberNotificationsController < ApplicationController
  unloadable

  def index
  end

  def update_jid
    if User.current.update_attributes(params[:user]) 
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'jabber_notifications', :action => 'index'
    else
      flash.now[:error] = l(:error_updating_jid)
      render :controller => 'jabber_notifications', :action => 'index'
    end
  end
end
