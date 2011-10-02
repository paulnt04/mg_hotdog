#Most of this is blatatently ripped out of the Tinder Gem. 
#https://github.com/collectiveidea/tinder

module Tinder
  class Room
    def message_stream(options = {})
      require 'active_support/json'
      require 'hashie'
      require 'multi_json'
      require 'twitter/json_stream'

      auth = connection.basic_auth_settings
      options = {
        :host => "streaming.#{Connection::HOST}",
        :path => room_url_for('live'),
        :auth => "#{auth[:username]}:#{auth[:password]}",
        :timeout => 6,
        :ssl => connection.options[:ssl]
      }.merge(options)

        @stream = Twitter::JSONStream.connect(options)


        @stream.on_error do |message|
          raise ListenFailed.new("got an error! #{message.inspect}!")
        end

        @stream.on_max_reconnects do |timeout, retries|
          raise ListenFailed.new("Tried #{retries} times to connect. Got disconnected from #{@name}!")
        end

        # if we really get disconnected
        raise ListenFailed.new("got disconnected from #{@name}!") if !EventMachine.reactor_running?

        @stream

    end    
  end
end

