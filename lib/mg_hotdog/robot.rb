require 'eventmachine'

module MgHotdog
  class Robot

    attr_accessor :parts
    attr_reader :room

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
          EM.defer { process MultiJson.decode(item), self }
        end
      end
    end   
    
    def process message
      puts message
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
