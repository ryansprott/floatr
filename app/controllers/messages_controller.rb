class MessagesController < ApplicationController
  def show
    @source = Source.includes(:messages).find(params[:source_id])

    @messages = @source.messages.details_by_type(params[:id])

    @message_table = MessageTable.new(@messages)
  end
end
