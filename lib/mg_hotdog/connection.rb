require 'tinder'

module MgHotdog
  class Connection
    def initialize
      @campfire = Tinder::Campfire.new("iclab", :token => ENV["CAMPFIRE_TOKEN"])
    end

    def open room_id
      @campfire.find_room_by_id room_id
    end
  end
end
