class SourcesController < ApplicationController
  def index
    @sources = Source.all
  end

  def show
    @source = Source.joins(:messages).find(params[:id])
  end
end
