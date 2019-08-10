# frozen_string_literal: true

class RoutingInfoDecorator < Draper::Decorator
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def status
    if !object.status.nil?
      I18n.t("routing_info.job_statuses.#{object.status}")
    else
      'Not Found'
    end
  end
end
