require 'spec_helper'
require 'mg_hotdog/parts/whatup_part'


  describe WhatupPart do
    describe "#process" do
      before :each do
        mock_message_and_robot
      end
      it "should say 'Whazzz up hommie' to the author of the message" do
        @message.stub(:body).and_return('whatup mg_hotdog')
        @robot.should_receive(:speak).with(/Whazzz up hommie/)
        WhatupPart.new.process(@message, @robot)
      end

      it "should not say hello to messages without a body" do
        @message.stub(:body).and_return( nil)
        @robot.should_not_receive(:speak)
        WhatupPart.new.process(@message, @robot)
      end
    end
  end

