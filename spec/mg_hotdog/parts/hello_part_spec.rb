require 'spec_helper'
require 'mg_hotdog/parts/hello_part'


  describe HelloPart do
    describe "#process" do
      before :each do
        mock_message_and_robot
      end
      ['hello','HeLlO','HEY','Hi'].each do |word|
        it "should say hello to the author of the message \"#{word} mg_hotdog\"" do
          @message.stub(:body).and_return("#{word} mg_hotdog")
          @robot.should_receive(:speak).with(/Hello #{@user.name}/)
          HelloPart.new.process(@message, @robot)
        end
      end

      it "should not say hello to the author of a mis-matched message" do
        @message.stub(:body).and_return('say \'hello mg_hotdog\'')
        @robot.should_not_receive(:speak)
        HelloPart.new.process(@message, @robot)
      end

      it "should not say hello to messages without a body" do
        @message.stub(:body).and_return( nil)
        @robot.should_not_receive(:speak)
        HelloPart.new.process(@message, @robot)
      end
    end
  end

