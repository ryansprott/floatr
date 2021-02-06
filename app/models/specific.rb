class Specific < ActiveRecord::Base
  self.abstract_class = true

  def method_missing(m, *args, &block)
    if m == :ship_name
      "Not provided"
    else
      super
    end
  end
end
