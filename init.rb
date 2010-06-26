require 'redmine'
# TODO Jabber menu should appear only to logged users!

Redmine::Plugin.register :redmine_jabber do
  name 'Redmine Jabber plugin'
  author 'Marek Hulán'
  description 'This is a jabber plugin for redmine'
  version '0.0.1'

  menu :account_menu, :jabber_notifications, { :controller => 'jabber_notifications', :action => 'index' }, :caption => 'Jabber'

  require_dependency 'app/models/mailer'
  require_dependency 'redmine_jabber/mailer'

  settings :default => {
    'bot_jid' => '',
    'bot_password' => ''
  }, :partial => 'settings/jabber_settings'
end
