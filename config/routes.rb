RedmineApp::Application.routes.draw do
  match 'jabber_notifications', :controller => 'jabber_notifications', :action => 'index'
  match 'jabber_notifications/update_jid', :controller => 'jabber_notifications', :action => 'update_jid'
  match 'jabber_notifications/authenticate', :controller => 'jabber_notifications', :action => 'authenticate'
end
