class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:update]

  def index
  end

  def pricing
    @locations = ["Albright Court", "Albright Woods", "Crowell Hall", "Krause Hall", "Moan Hall", "North Hall", "Rockland Hall", "Smith Hall", "Walton Hall"]
  end

  def home
  end

  def about
  end

  def contact
  end

  def pages
  end
end
