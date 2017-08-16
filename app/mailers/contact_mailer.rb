class ContactMailer < ApplicationMailer
  # default from: "youcanreach_will@icloud.com"

  def sample_email(email)
    mail(to: email, subject: 'Sample Email')
  end
end
