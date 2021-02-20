class LiveMapsController < ApplicationController
  def index
    @messages = Message.where(created_at: 1.hour.ago..)
      .includes(:position)
      .order(:updated_at)
      .group_by(&:mmsi)

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end
end
