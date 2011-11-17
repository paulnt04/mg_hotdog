require 'spec_helper'
require 'mg_hotdog/parts/welcome_part.rb'

describe WelcomePart do

  before :each do
    mock_message_and_robot
    mock_ignored_user_db
  end
  it "should shout PABLO!!!!! when paul enters" do
    @message.stub(:type).and_return("EnterMessage")
    @user.stub(:name).and_return( "Paul Panarese" )

    @robot.should_receive(:speak).with(/PABLO!!!!!/)

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should not respond to paul's text messages" do
    @message.stub(:type).and_return( "TextMessage")
    @user.stub(:name).and_return( "Paul Panarese")

    @robot.should_not_receive :speak

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should respond normally to someone else's enter message" do
    @message.stub(:type).and_return( "EnterMessage")
    @user.stub(:name).and_return("Ethan Soutar-rau")
    @robot.should_receive(:speak).with(/Welcome\ Ethan\ Soutar\-rau/)

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should not respond to normal text messages" do
    @message.stub(:type).and_return("TextMessage")
    @user.stub(:name).and_return("Ethan Soutar-rau")
    @robot.should_not_receive :speak

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should add a user to ignored_users" do
    @message.stub(:type).and_return("TextMessage")
    @message.stub(:body).and_return("Fuck off mg_hotdog")
    @user.stub(:name).and_return('Ethan Soutar-rau')
    @db.stub(:execute).with('select * from ignored_users').and_return([])
    @db.should_receive(:execute).with("insert into ignored_users values ('Ethan Soutar-rau')")
    @robot.should_receive(:speak).with("I will no longer acknowledge when Ethan Soutar-rau enters this room.")

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should remove a user from ignored_users" do
    @message.stub(:type).and_return("TextMessage")
    @message.stub(:body).and_return("Please Welcome me MG_HOTDOG")
    @db.stub(:execute).with('select * from ignored_users').and_return(['Ethan Soutar-rau'])
    @user.stub(:name).and_return('Ethan Soutar-rau')
    @db.should_receive(:execute).with("delete from ignored_users where name=='Ethan Soutar-rau'")
    @robot.should_receive(:speak).with("I will now acknowledge when Ethan Soutar-rau enters this room.")

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should not add a user already in ignored users" do
    @message.stub(:type).and_return("TextMessage")
    @message.stub(:body).and_return("Fuck off mg_hotdog")
    @db.stub(:execute).with('select * from ignored_users').and_return(['Ethan Soutar-rau'])
    @user.stub(:name).and_return('Ethan Soutar-rau')
    @db.should_not_receive(:execute).with("insert into ignored_users values ('Ethan Soutar-rau')")
    @robot.should_not_receive(:speak)

    WelcomePart.new(@db).process(@message,@robot)
  end

  it "should not respond to a user in ignored_users" do
    @message.stub(:type).and_return("EnterMessage")
    @user.stub(:name).and_return('Ethan Soutar-rau')
    @db.stub(:execute).with('select * from ignored_users').and_return(['Ethan Soutar-rau'])
    @robot.should_not_receive(:speak)

    WelcomePart.new(@db).process(@message,@robot)
  end
end
