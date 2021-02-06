class Position < ApplicationRecord
  belongs_to :message, optional: true

  def to_s
    "#{latitude}, #{longitude}"
  end
end
