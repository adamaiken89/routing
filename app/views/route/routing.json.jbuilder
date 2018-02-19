if @result
  json.token @routing_info.token
else
  json.error @error_message
end