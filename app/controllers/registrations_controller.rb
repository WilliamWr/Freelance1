class RegistrationsController < Devise::RegistrationsController
  
  private

  def sign_up_params
    params.require(:user).permit(:schoolname, :schoolyear, :firstname, :middleinitial, :lastname, :email, :studenphonenumber, :password, :password_confirmation, :parentfirstname, :parentmiddleinitial, :parentlastname, :parentmiddleinitial, :parentphonenumber, :parentemail)
  end

  def account_update_params
    params.require(:user).permit(:schoolname, :schoolyear, :firstname, :middleintial, :lastname, :email, :studentphonenumber, :password, :password_confirmation, :current_password, :parentfirstname, :parentmiddleinitial, :parentlastname, :parentmiddleinitial, :parentphonenumber, :parentemail)
  end
end
