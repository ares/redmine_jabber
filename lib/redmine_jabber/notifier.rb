# encoding: UTF-8
require 'blather/client/client'
class RedmineJabber::Notifier < Blather::Client
  def self.send_message(jid, message)
    settings = Setting.plugin_redmine_jabber.with_indifferent_access
    client = self.setup(settings[:bot_jid], settings[:bot_password])
    client.register_handler(:ready) do
      client.write Blather::Stanza::Message.new(jid, message)
      client.close
    end
    EM.run { client.run }
  end
end
