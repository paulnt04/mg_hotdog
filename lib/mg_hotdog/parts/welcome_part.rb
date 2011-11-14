class WelcomePart
  def process(message, robot)
    if message.type =~ /EnterMessage/ && message.user.name =~ /Paul Panarese/
      robot.speak("PABLO!!!!!")
    elsif message.type =~ /EnterMessage/
      robot.speak("Welcome #{message.user.name}")
    end
  end
end
