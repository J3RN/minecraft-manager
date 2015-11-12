class MainController < ApplicationController
  def index
    redirect_to phoenixes_url if user_signed_in?
  end
end
