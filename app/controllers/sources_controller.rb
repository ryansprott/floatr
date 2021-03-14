class SourcesController < ApplicationController
  def index
    @sources = Source.recent(params[:offset])

    respond_to do |format|
      format.html { }
      format.json { render :index }
    end
  end

  def show
    @source = Source.includes(:messages).find(params[:id])

    @messages = @source.messages

    @positions = @messages.joins(:position).order(:created_at)
  end
end
