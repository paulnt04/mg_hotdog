require 'spec_helper'

module MgHotdog
  describe Connection do
    describe "Open a room" do
      it "should require a room number" do
        lambda { 
          Connection.new.open
        }.should raise_error ArgumentError
      end

      it "should return a room"

    end
  end
end
