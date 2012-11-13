# encoding: UTF-8
class MailObserver

  def self.delivered_email(mail)
    # redmine actually stores recipeints in bcc
    return mail if mail.to.nil? && mail.bcc.nil?
    to = ([mail.to] + [mail.bcc]).flatten.compact.uniq
    to.each do |email|
      if (user = User.find_by_mail(email)) && user.jid.present? && user.jid_authenticated
        footer  = Setting[:emails_footer].gsub(/\r\n/, "\n")
        part = mail.body.parts.select {|p| p.content_type =~ /text\/plain/}.first # plaintext
        message = part.body.to_s.gsub(/#{footer}.*/m, "").gsub(/[-]{3,}/, "\n").gsub(/[\n]{3,}/, "\n\n").strip
        RedmineJabber::Notifier.send_message(user.jid, message)
      end
    end
  end

end
