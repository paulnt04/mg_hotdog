require 'spec_helper'
require 'mg_hotdog/parts/welcome_part.rb'

describe WelcomePart do

  before :each do
    mock_message_and_robot
  end
  it "should shout PABLO!!!!! when paul enters" do
    @message.stub(:type).and_return("EnterMessage")
    @user.stub(:name).and_return( "Paul Panarese" )

    @robot.should_receive(:speak).with(/PABLO!!!!!/)

    WelcomePart.new.process(@message,@robot)
  end

  it "should not respond to paul's text messages" do
    @message.stub(:type).and_return( "TextMessage")
    @user.stub(:name).and_return( "Paul Panarese")

    @robot.should_not_receive :speak

    WelcomePart.new.process(@message,@robot)
  end

  it "should respond normally to someone else's enter message" do
    @message.stub(:type).and_return( "EnterMessage")
    @user.stub(:name).and_return("Ethan Soutar-rau")
    @robot.should_receive(:speak).with(/Welcome\ Ethan\ Soutar\-rau/)

    WelcomePart.new.process(@message,@robot)
  end

  it "should not respond to normal text messages" do
    @message.stub(:type).and_return("TextMessage")
    @user.stub(:name).and_return("Ethan Soutar-rau")
    @robot.should_not_receive :speak

    WelcomePart.new.process(@message,@robot)
  end
end
