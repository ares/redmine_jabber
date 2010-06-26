require_dependency 'app/models/mailer'
require_dependency 'redmine_jabber/mailer'

class JabberNotificationsController < ApplicationController
  # TODO define some authorization!
  unloadable

  def index
  end

  def update_jid
    User.current.attributes = params[:user].merge({:jid_token => generate_token, :jid_authenticated => false})
    if User.current.jid_was != User.current.jid

      # send notification only if user set some jid
      if User.current.jid.present?
        RedmineJabber::Notifier.send_message(User.current.jid,
          l(:jid_confirmation_message, :url => url_for(:controller => 'jabber_notifications', 
            :action => 'authenticate', :token => User.current.jid_token, :jid => User.current.jid)))
      end

      if User.current.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to :controller => 'jabber_notifications', :action => 'index'
      else
        flash.now[:error] = l(:error_updating_jid)
        render :controller => 'jabber_notifications', :action => 'index'
      end
      return
    end
    
    flash.now[:error] = l(:error_jid_not_changed)
    render :controller => 'jabber_notifications', :action => 'index'
  end

  def authenticate
    user = User.find_by_jid(params[:jid])
    if user && user.jid_token == params[:token] && !user.jid_authenticated &&
        user.update_attribute(:jid_authenticated, true)
      RedmineJabber::Notifier.send_message(user.jid, l(:jid_authenticated_message))
      flash.now[:notice] = l(:notice_sucessful_authentication)
    else
      flash.now[:error] = l(:error_during_authentication)
    end
  end

  protected

  PASSWORD_CHARS = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'.split('')
  def generate_token(length = 20)
    Array.new(length) {|_| PASSWORD_CHARS.rand }.join
  end

end
