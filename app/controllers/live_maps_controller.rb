class LiveMapsController < ApplicationController
  def index

    respond_to do |format|
      format.html { }
      format.json do
        @messages = Message.recent
        render :index
      end
    end
  end
end
