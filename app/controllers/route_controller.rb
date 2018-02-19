class RouteController < ApplicationController
  before_action :set_routing_info, only: [:driving_info]

  # POST /route
  #### Input body:
  # [
  #   ["ROUTE_START_LATITUDE", "ROUTE_START_LONGITUDE"],
  #   ["DROPOFF_LATITUDE_#1", "DROPOFF_LONGITUDE_#1"],
  #   ...
  # ]
  #### Response body:
  # HTTP code 200
  # { "token": "TOKEN" }
  # or
  # { "error": "ERROR_DESCRIPTION" }
  #### Input body example:
  # [
  #   ["22.372081", "114.107877"],
  #   ["22.284419", "114.159510"],
  #   ["22.326442", "114.167811"]
  # ]
  #### Response example:
  # { "token": "9d3503e0-7236-4e47-a62f-8b01b5646c16" }
  def routing
    begin
      routing_input = JSON.parse(request.body.read)
      @routing_info = RoutingInfo.new({routing_input: routing_input})
      @result = @routing_info.save
      if @result
        MapJob.perform_later(@routing_info.id)
      else
        @error_message = @routing_info.errors.messages.first[1].first + 
        ' It should look like the followings: [  ["ROUTE_START_LATITUDE", "ROUTE_START_LONGITUDE"],  ["DROPOFF_LATITUDE_#1", "DROPOFF_LONGITUDE_#1"],  ... ]'
      end
    rescue JSON::ParserError
      # Handle parsing error
      @result = false
      Rails.logger.info "JSON Parse Error." + request.body.read
      @error_message = "The input body is not a json object."
    end

  end

  # GET /route/:token
  #### Response body:
  # HTTP 200
  # {
  #   "status": "success",
  #   "path": [
  #     ["ROUTE_START_LATITUDE", "ROUTE_START_LONGITUDE"],
  #     ["DROPOFF_LATITUDE_#1", "DROPOFF_LONGITUDE_#1"],
  #     ...
  #   ],
  #   "total_distance": DRIVING_DISTANCE_IN_METERS,
  #   "total_time": ESTIMATED_DRIVING_TIME_IN_SECONDS
  # }
  # or
  # {
  #   "status": "in progress"
  # }
  # or
  # {
  #   "status": "failure",
  #   "error": "ERROR_DESCRIPTION"
  # }
  #### URL example:
  # /route/9d3503e0-7236-4e47-a62f-8b01b5646c16
  #### Response example:
  # {
  #   "status": "success",
  #   "path": [
  #     ["22.372081", "114.107877"],
  #     ["22.326442", "114.167811"],
  #     ["22.284419", "114.159510"]
  #   ],
  #   "total_distance": 20000,
  #   "total_time": 1800
  # }
  def driving_info
    if @routing_info.present?
      # Do Nothing
    else
      @routing_info = RoutingInfo.new({status: RoutingInfo::STATUS_FAILED })
      @error_message = "The token is not found."
    end
  end

  private
    def set_routing_info
      @routing_info = RoutingInfo.find_by(token: params[:token])
    end
end
