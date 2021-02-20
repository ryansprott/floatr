class SourcesController < ApplicationController
  def index
    @sources = Source.order(:created_at).reverse
  end

  def show
    @source = Source.includes(:messages).find(params[:id])
    @messages = @source.messages
    @positions = @messages.joins(:position).order(:created_at)
  end
end
