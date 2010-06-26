class Mailer < ActionMailer::Base

  alias_method :create_without_messenger!, :create!
  
  def create!(method_name, *parameters)
    mail = create_without_messenger!(method_name, *parameters)

    # redmine actually stores recipeints in bcc
    return mail if mail.to.nil? && mail.bcc.nil?
    
    message = nil
    
    to = ([mail.to] + [mail.bcc]).flatten.compact.uniq
    
    to.each do |email|
      if (user = User.find_by_mail(email)) && user.jid.present? && user.jid_authenticated
        if message.nil?
          footer = Setting[:emails_footer].gsub(/\r\n/, "\n")
          message = mail.body.gsub(/#{footer}.*/m, "").gsub(/[-]{3,}/, "\n").gsub(/[\n]{3,}/, "\n\n").strip
        end
        RedmineJabber::Notifier.send_message(user.jid, message)
      end
    end

    mail
  end
    
end
