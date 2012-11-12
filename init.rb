# encoding: UTF-8
require 'redmine'

Redmine::Plugin.register :redmine_jabber do
  name 'Redmine Jabber plugin'
  author 'Marek Hulán'
  description 'This is a jabber plugin for redmine'
  version '0.0.1'

  menu :account_menu, :jabber_notifications, { :controller => 'jabber_notifications', :action => 'index' },
    :caption => 'Jabber', :if => Proc.new{ !User.current.kind_of?(AnonymousUser) }, :before => :logout

  require 'redmine_jabber/mail_observer'
  ActionMailer::Base.register_observer(MailObserver)

  settings :default => {
    'bot_jid' => '',
    'bot_password' => ''
  }, :partial => 'settings/jabber_settings'
end
