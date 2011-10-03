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
      puts @parts.inspect
       @room = @campfire.open(@room_id)

       @room.listen do |message|
         process(message)
       end
    end

    def process message
      @parts.each do | pattern, part, type|
        EM.defer {
          if message[type] && message[type].match(pattern)
            part.process(message, self) 
          end
        }
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
