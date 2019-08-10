# frozen_string_literal: true

class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end
