class MapJob < ApplicationJob
  queue_as :default

  # rescue_from(ErrorLoadingSite) do
  #   retry_job wait: 5.minutes, queue: :low_priority 
  # end 

  # def perform(*args)
  def perform(routing_id)
    # Do something later
    @routing_info = RoutingInfo.find(routing_id)
    distance = nil
    duration = nil
    routing_output = {}

    origin = @routing_info.routing_input[0]
    destinations = @routing_info.routing_input[1..-1]
    iterations = destinations.size
    iterations.times do |iteration|
      proposed_destination = destinations.shift  
      destinations = destinations + [proposed_destination]

      @routing_info.status = RoutingInfo::STATUS_NET_ERR

      response_data = get_map_data(origin, destinations)
      
      if response_data.present?
        response_data['routes'].each do |route|
          tmp_distance = 0
          tmp_duration = 0
          tmp_path = nil
          route["legs"].each do |item|
            tmp_distance += item['distance']['value']
            tmp_duration += item['duration']['value']
          end
          if !distance.present? || (distance > tmp_distance)
            distance = tmp_distance
            duration = tmp_duration
            routing_output = ([origin] + route['waypoint_order'].map do |order|
              destinations[order]
            end + [proposed_destination])
          end
        end
      end

      if @routing_info.status != RoutingInfo::STATUS_COMPLETE
        break
      end
    end

    @routing_info.driving_distance_in_meters = distance
    @routing_info.estimated_driving_time_in_seconds = duration
    @routing_info.routing_output = routing_output
    @routing_info.save
  end

  private
  def get_map_data(origin, destinations)
    @google_map ||= GoogleMap.new
    response = @google_map.direction(origin, destinations)
    response_data = response.parsed_response
    case response.code
    when 200
      # Success
      if response_data["status"] == "OK"
        @routing_info.status = RoutingInfo::STATUS_COMPLETE
        return response_data
      else
        @routing_info.status = RoutingInfo::STATUS_FAILED
        Rails.logger.info "Cannot find a route."
        Rails.logger.info response_data
      end
    when 404
      Rails.logger.info "The api path is not found."
    when 500...600
      Rails.logger.info "Server side internal error. Status Code: #{response.code}"
    else
      # Failed
      Rails.logger.info "Unexpected error. Status Code: #{response.code}"
    end

    return nil
  end
end
