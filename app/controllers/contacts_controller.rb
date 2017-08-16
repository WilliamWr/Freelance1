
class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save!
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to pages_contact_path
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
