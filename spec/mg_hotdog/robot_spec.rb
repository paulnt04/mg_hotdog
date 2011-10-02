require 'spec_helper'

module MgHotdog
  describe Robot do

    describe "creating a robot" do
      it "should connect to a room" do
        room_number = 41235
        connection = double()
        Connection.stub(:new).and_return connection
        connection.should_receive(:open).with(room_number)

        Robot.new(room_number)
      end
    end
  end
end
