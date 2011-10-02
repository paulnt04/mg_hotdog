require 'spec_helper'
require 'mg_hotdog/parts/whatup_part'


  describe WhatupPart do
    describe "#process" do
      before :each do
        mock_message_and_robot
      end
      it "should say 'Whazzz up hommie' to the author of the message" do

        @robot.should_receive(:speak).with(/Whazzz up hommie/)
        WhatupPart.new.process(@message, @robot)
      end
    end
  end

