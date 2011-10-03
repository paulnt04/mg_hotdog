class WhatupPart

  def process(message, robot)
    if message.body && message.body.match(/whatup mg_hotdog/i)
    robot.speak("Whazzz up hommie")
    end
  end

end
