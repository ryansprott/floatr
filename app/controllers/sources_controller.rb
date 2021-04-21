class SourcesController < ApplicationController
  def index
    @sources = Source.recent(params[:offset])

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
