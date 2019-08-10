# frozen_string_literal: true

class CreateRoutingInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :routing_infos do |t|
      t.string :token
      t.json :routing_input
      t.bigint :driving_distance_in_meters
      t.bigint :estimated_driving_time_in_seconds
      t.string :status, default: 'processing'
      t.timestamps
    end
    add_index :routing_infos, [:token], unique: true
  end
end
