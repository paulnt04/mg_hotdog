class PabloPart
  def process(message, robot)
    robot.speak('PABLO!!!!!') if message.type =~ /EnterMessage/ && message.user.name =~ /Paul Panarese/ 
  end
end
