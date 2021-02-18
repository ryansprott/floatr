class MessagesController < ApplicationController
  def show
    @source = Source.find(params[:source_id])
    @messages = @source.messages
      .where(type: params[:id].to_i)
      .includes("type_#{params[:id]}_specific".to_sym, :dimension)
  end
end
