# frozen_string_literal: true

class AddOutputpathToRoutingInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :routing_infos, :routing_output, :json
  end
end
