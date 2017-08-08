class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:update]

  def index
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
