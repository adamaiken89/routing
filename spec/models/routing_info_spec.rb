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

require 'rails_helper'

RSpec.describe RoutingInfo, type: :model do
  describe '#routing_input' do
    let(:routing_info){ RoutingInfo.new }
    it "should store correctly with one origin and one desination" do
      routing_info.routing_input = [
        ["22.372081", "114.107877"],
        ["22.284419", "114.159510"]
      ]
      expect(routing_info.save).to eq(true)
    end
    it "should store correctly with one origin and two desinations" do
      routing_info.routing_input = [
        ["22.372081", "114.107877"],
        ["22.284419", "114.159510"],
        ["22.326442", "114.167811"]
      ]
      expect(routing_info.save).to eq(true)
    end
    it "should NOT store with one origin only" do
      routing_info.routing_input = [
        ["22.372081", "114.107877"]
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with one origin with missing longitude, and a correct desination" do
      routing_info.routing_input = [
        ["22.372081"],
        ["22.284419", "114.159510"],
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with one origin only with wrong format" do
      routing_info.routing_input = [
        ["2aaafdsfs", "114.107877"],
        ["22.284419", "114.159510"],
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with one origin with more than two values and one desination" do
      routing_info.routing_input = [
        ["22.372081", "114.107877", "114.107877"],
        ["22.284419", "114.159510"]
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with a correct origin, and an incorrect destination with missing longitude" do
      routing_info.routing_input = [
        ["22.372081", "114.107877"],
        ["22.284419"],
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with a correct origin, and a destination with more than two values " do
      routing_info.routing_input = [
        ["22.372081", "114.107877"],
        ["22.284419", "114.159510", "114.159510"]
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with a correct origin and a destination with wrong format" do
      routing_info.routing_input = [
        ["22.372081", "114.107877"],
        ["22.aaa", "114.159510"],
      ]
      expect(routing_info.save).to eq(false)
    end
    it "should NOT store with an empty json object" do
      routing_info.routing_input = [
      ]
      expect(routing_info.save).to eq(false)
    end
  end

end
