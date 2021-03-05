class LiveMapsController < ApplicationController
  def index
    @messages = Message.where(created_at: 15.minutes.ago..)
      .includes(:source, :position, :course)
      .order(:updated_at)
      .group_by(&:mmsi)

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end
end
