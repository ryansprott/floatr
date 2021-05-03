class SourcesController < ApplicationController
  def index
    @recently_added = Source.recently_added
    @recently_seen = Source.recently_seen

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end

  def show
    @source = Source.includes(:messages, :mysteries).find(params[:id])

    @messages = @source.messages

    @positions = @messages.joins(:position, :course).order(:created_at) - @source.mysteries
  end
end
