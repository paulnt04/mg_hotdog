$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rspec'
require 'tinder'
require 'mg_hotdog'
require 'fakeweb'

FakeWeb.allow_net_connect = false

ENV["CAMPFIRE_TOKEN"] = "somethingfake"


def mock_message_and_robot
        @robot = double()

        @user = double()
        @user.stub(:name).and_return('bob')

        @message = double()
        @message.stub(:user).and_return(@user)
end

def mock_ignored_user_db
  @message.stub(:body)
  @db = double()
  @db.stub(:execute).with('select * from ignored_users').and_return([])
  @db.stub(:execute).with('create table ignored_users (name varchar(255))')
end
