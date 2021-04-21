class MessagesController < ApplicationController
  def show
    @source = Source.includes(:messages, :mysteries).find(params[:source_id])

    @messages = @source.messages.details_by_type(params[:id]) - @source.mysteries

    @message_table = MessageTable.new(@messages)
  end
end
