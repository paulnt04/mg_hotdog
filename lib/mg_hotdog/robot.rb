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


    end    
  end
end



require 'eventmachine'

module MgHotdog
  class Robot

    attr_accessor :parts
    attr_reader :room

    def initialize(room_number)
      @parts = []
      @campfire = Connection.new
      @room = @campfire.open(room_number)
    end

    def wake_up
      puts @parts.inspect
      @room.join
      EventMachine::run do
        @stream = @room.message_stream

        @stream.each_item do |message|
          puts message
        end

        @stream.on_error do |message|
          raise ListenFailed.new("got an error! #{message.inspect}!")
        end

        @stream.on_max_reconnects do |timeout, retries|
          raise ListenFailed.new("Tried #{retries} times to connect. Got disconnected from #{@name}!")
        end

        # if we really get disconnected
        raise ListenFailed.new("got disconnected from #{@name}!") if !EventMachine.reactor_running?

      end
    end   

    def listen(pattern, responder)
      @parts << [pattern, responder, :body]
    end

    def listen_for(pattern, options)
      @parts << [pattern, options[:with], options[:in]]
    end

    def speak message
      @room.speak message
    end
  end

end
