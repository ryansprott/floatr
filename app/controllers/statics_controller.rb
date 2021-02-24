class StaticsController < ApplicationController
  def show
    source = Source.find(params[:source_id])

    messages = source
      .messages
      .where(type: params[:id].to_i)
      .includes(
        "type_#{params[:id]}_specific".to_sym,
        :dimension,
      )

    @message_headers = messages
      .first
      .specific_attributes
      .keys
      .map(&:titleize)
      .map(&:humanize)

    @message_rows = messages
      .map(&:specific_attributes)
      .map(&:values)
      .uniq

    @dimension_headers = messages
      .first
      .dimension_attributes
      .keys
      .map(&:titleize)
      .map(&:humanize)

    @dimension_rows = messages
      .map(&:dimension_attributes)
      .map(&:values)
      .uniq
    end
end
