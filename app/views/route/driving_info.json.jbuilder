json.status @routing_info.decorate.status
if @routing_info.new_record?
  json.error @error_message
elsif @routing_info.status_complete?
  json.path @routing_info.routing_output
  json.total_distance @routing_info.driving_distance_in_meters
  json.total_time @routing_info.estimated_driving_time_in_seconds
elsif @routing_info.status_failed?
  json.error "Route not found."
elsif @routing_info.status_net_error?
  json.error "System internal error. Please try it later."
elsif  @routing_info.status_processing?
  # For Processing Status, do nothing
else
  # No status Do Nothing too
end
