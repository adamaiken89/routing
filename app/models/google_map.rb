class GoogleMap
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/'

  def initialize(output_format='json')
    @base_options = {key: ENV.fetch("GOOLGE_MAP_API_KEY")}
    @output_format = output_format
  end

  def direction(origin, destinations, units="metric")
    options = @base_options.merge({ units: units,
      origin: origin.join(","), 
      waypoints: "optimize:true|" + destinations[0..-2].map{|ri| ri.join(",") }.join("|"),
      destination: destinations.last.join(","),
      alternatives: true,
    })
    self.class.get("/directions/#{@output_format}", query: options)
  end

end