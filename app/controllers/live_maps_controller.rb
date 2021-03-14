class LiveMapsController < ApplicationController
  def index
    @messages = Message.recent

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end
end
