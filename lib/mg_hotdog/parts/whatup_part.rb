class WhatupPart

  def process(message, robot)
    if message.body && message.body.match(/^(w(h)?at(\'s\s)?up|w(h)?azzup) mg_hotdog/i)
    robot.speak("Whazzz up hommie")
    end
  end

end
