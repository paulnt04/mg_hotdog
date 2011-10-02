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
          EM.defer { route message }
        end
      end
    end   
    
    def route message
      puts message
      @parts.each do |part|
        if message.body && message[part[2]].match(part[0])
          EM.defer { part[1].process(message, self) }
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
