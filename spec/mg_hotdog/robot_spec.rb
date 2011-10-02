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

        params = {body: 'something cool'}

        robot = Robot.new(@room_number)

        part = double()
        part.stub(:process)
        part.should_receive(:process).with(params, robot)

        robot.listen /.*/, part 

        robot.process(params)
      end

    end
  end
end
