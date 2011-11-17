require 'spec_helper'

module MgHotdog
  describe Robot do
    before(:each) do
      @room_id = 341232
      @db_path = 'db/test.sqlite'
    end
    describe "creating a robot" do
      it "should accept a room id and database path" do
        Robot.new(@room_id,@db_path)
      end

      it "should set up a connection" do
        Connection.should_receive(:new)
        Robot.new(@room_id,@db_path)
      end

      it "should set up a database" do
        Database.should_receive(:new)
        Robot.new(@room_id,@db_path)
      end
    end

    describe "processing messages" do
      it "should delegate processing to parts" do
        params = Hashie::Mash.new( {body: 'something cool'})

        robot = Robot.new(@room_number,@db_path)

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
