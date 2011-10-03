class HelloPart
  def process(message, robot)
    if message.body && message.body.match(/hello mg_hotdog/i)
      robot.speak("Hello #{message.user.name}.") 
    end
  end
end
