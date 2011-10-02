require 'eventmachine'

module MgHotdog
  class Robot

    attr_accessor :parts
    attr_accessor :room

    def initialize(room_number)
      @parts = []
      @campfire = Connection.new
      @room_id = room_number
    end

    def wake_up
       @room = @campfire.open(@room_id)

      puts @parts.inspect
      @room.join
      EventMachine::run do
        @stream = @room.message_stream

        @stream.each_item do |item|
           message = Hashie::Mash.new MultiJson.decode(item) 
           puts message.inspect

          self.process( message)
        end
      end
    end   
    
    #paritally borrowed from Tinder
    def process message

      message["user"] = @room.user(message["user_id"])
      @parts.each do | pattern, part, type|
        if message[type] && message[type].match(pattern)
          part.process(message, self) 
        end
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
