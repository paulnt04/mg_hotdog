class PianobarPart
  require 'pianobar-connector'
  require 'rbconfig'

  def process(message, robot)
    #if message =~ /mg_hotdog[,\s]{1,2}/ # Commented for new robot.listen
      command = message.gsub(/mg_hotdog[,\s]{1,2}/,'')
      case command
      when /^play\s(some\s)?music/i
        @piano = Pianobar::Connector.new({:user => 'icl@gmail.com', :password => ENV['pandora_password']})
        if @piano
          robot.room.speak("Music is now playing")
        else
          robot.room.speak("There was an error starting the music")
        end
      when /^list\s([Pp](ianobar|andora)\s)?[Ss]tations/
        robot.room.speak(@piano.list.collect{|station| "#{station.name}\n"}
      when /^(play|select)\s([Ss]tation\s)?(?<station>.+)/
        if @piano.station(Regexp.last_match(:station))
          robot.room.speak("Station has been changed to #{@piano.station}")
        else
          robot.room.speak("There was an error changing the station to #{Regexp.last_match(:station)}")
        end
      when /^pause\s(the\s)?music/i
        @piano.pause
        if @piano.paused?
          robot.room.speak("The music has been paused")
        else
          robot.room.speak("There was an error pausing the music")
        end
      when /^(make|create)\s(a\s)?new\s[Ss]tation\s(from|with|using)\s(artist|genre|song)\s(?<station>.+)/
        if @piano.create_station(Regexp.last_match(:station))
          robot.room.speak("Station has been created")
        else
          robot.room.speak("Station was not able to be created")
        end
      when /^show\sme\sthe\s(music\s)?commands/
       robot. room.speak(%[])
      when /^stop\s(the\s)?music/i
        @piano.stop
        if @piano.stopped?
          robot.room.speak("The music has been stopped")
        else
          robot.room.speak("There was an error exiting pianobar")
        end
      when /^show\s(me\s)?the\scurrent\svolume(\slevel)/
        case Config::CONFIG['host_os']
        when /darwin/
          settings = %x[osascript -e 'get volume settings']
          if $?.success?
            settings.match(/output\svolume:(?<volume>\d+)/)
            robot.room.speak("Current volume is at #{Regexp.last_match(:volume)}%")
          else
            robot.room.speak("There was an error retrieving the volume")
          end
        else
          robot.room.speak("This option is not yet supported in this OS")
        end
      when /^set\s(the\s)?(current\s)?volume\sto\s(?<volume>\.+)/
        if volume =~ /((\d+)|((max|min)(imum)?))/
          message = @piano.set_volume(Regexp.last_match(:volume))
          robot.room.speak(message)
        else
          robot.room.speak("There was an error with your volume. Please use [0-10/max/min]")
        end
      when /^mute\s(the\smusic)?/
        @piano.set_volume(0)
      when /^lower\s(the\s)?volume/
        @piano.decrement_volume
      when /^raise\s(the\s)?volume/
        @piano.increment_volume
      when /^((tell\sme)|(what\sis))\sthe\s(current\s)?song(\sis)?/
        robot.room.speak(@piano.current_song)
      when /^like\s(((the)|(this))\s)?(current\s)?song/
        @piano.thumbs_up
      when /^(hate|dislike)\s(((the)|(this))\s)?(current\s)?song/
        @piano.thumbs_down
      end
    #end
  end

end
