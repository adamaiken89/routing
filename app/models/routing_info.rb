# == Schema Information
#
# Table name: routing_infos
#
#  id                                :integer          not null, primary key
#  token                             :string
#  routing_input                     :json
#  driving_distance_in_meters        :integer
#  estimated_driving_time_in_seconds :integer
#  status                            :string           default("processing")
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  routing_output                    :json
#
# Indexes
#
#  index_routing_infos_on_token  (token) UNIQUE
#

class RoutingInfo < ApplicationRecord
  before_create :set_token
  JOB_STATUSES = %w(processing failed net_error complete)

  STATUS_PROCESSING = JOB_STATUSES[0]
  STATUS_FAILED = JOB_STATUSES[1]
  STATUS_NET_ERR = JOB_STATUSES[2]
  STATUS_COMPLETE = JOB_STATUSES[3]

  validates :status, inclusion: { in: JOB_STATUSES }
  validates :token, uniqueness: true

  validate :format_of_routing_info
  validate :format_of_routing_info_origins
  validate :format_of_routing_info_destinations
 
  JOB_STATUSES.each do |attr|
    define_method "status_#{attr}?" do
      self.status == attr.to_s
    end
  end

  private
    def set_token
      self.token = SecureRandom.uuid
    end

    def format_of_routing_info
      if self.routing_input.present?
        # Do Nothing
      else
        errors.add(:routing_input, "Please specify both the origin and desintations.")
      end
    end
    
    def format_of_routing_info_origins
      origin = self.routing_input.try(:first)
      if origin && origin.size == 2 && origin[0].try(:numeric?) && origin[1].try(:numeric?)
        # Do Nothing
      else
        errors.add(:routing_input, "Origin should be with numeric latitude and longitude only having double quotes around.")
      end
    end
    
    def format_of_routing_info_destinations
      destinations = self.routing_input[1..-1]

      if destinations.present? && destinations.size > 0
        if destinations.size > 24
          errors.add(:routing_input, "Destinations should be input with at most 24 points.")
          return
        end
        
        destinations.each do |destination|
          if destination.size == 2 && destination[0].try(:numeric?) && destination[1].try(:numeric?) 
            # Do Nothing
          else
            errors.add(:routing_input, "Destinations should be with numeric latitude and longitude only having double quotes around.")
          end
        end
      else
        errors.add(:routing_input, "Please specify at least one desintations.")
      end
    end
end
