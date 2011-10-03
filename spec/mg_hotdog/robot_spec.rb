require 'spec_helper'

module MgHotdog
  describe Robot do

    describe "creating a robot" do
      before do
        @room_id = 341232
      end

      it "should accept a room id" do
        Robot.new(@room_id)
      end

      it "should set up a  connection" do
        Connection.should_receive(:new)
        Robot.new(@room_id)
      end
    end

    describe "processing messages" do
      it "should delegate processing to parts" do
        params = Hashie::Mash.new( {body: 'something cool'})

        robot = Robot.new(@room_number)

        robot.room = double()
        robot.room.stub(:user).and_return(nil)

        part = double()
        part.stub(:process)
        part.should_receive(:process)

        robot.parts << part

        EM::run do
        robot.process(params)
        EM.stop
        end
      end

    end
  end
end
