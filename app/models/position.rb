class Position < ActiveRecord::Base
  belongs_to :message, optional: true

  def to_s
    "#{latitude}, #{longitude}"
  end
end
