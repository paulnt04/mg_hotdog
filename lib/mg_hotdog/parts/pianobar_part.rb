class PianobarPart
  require 'pianobar-connector'

  def process(message, room)
    if message =~ /mg_hotdog[,\s]{1,2}/
      command = message.gsub(/mg_hotdog[,\s]{1,2}/,'')
      case command
      when /^play\s(some\s)?music/i
        @piano = Pianobar::Connector.new({:user => 'icl@gmail.com', :password => ENV['pandora_password']})
        if @piano
          room.speak("Music is now playing")
        else
          room.speak("There was an error starting the music")
        end
      when /^list\s([Pp](ianobar|andora)\s)?[Ss]tations/
        room.speak(@piano.list.collect{|station| "#{station.name}\n"}
      when /^(play|select)\s([Ss]tation\s)?(?<station>.+)/
        if @piano.station(Regexp.last_match(:station))
          room.speak("Station has been changed to #{@piano.station}")
        else
          room.speak("There was an error changing the station to #{Regexp.last_match(:station)}")
        end
      when /^pause\s(the\s)?music/i
        @piano.pause
        if @piano.paused?
          room.speak("The music has been paused")
        else
          room.speak("There was an error pausing the music")
        end
      when /^(make|create)\s(a\s)?new\s[Ss]tation\s(from|with|using)\s(artist|genre|song)\s(?<station>.+)/
        if @piano.create_station(Regexp.last_match(:station))
          room.speak("Station has been created")
        else
          room.speak("Station was not able to be created")
        end
      when /^show\sme\sthe\s(music\s)?commands/
        room.speak(%[])
      when /^stop\s(the\s)?music/i
        @piano.stop
        if @piano.stopped?
          room.speak("The music has been stopped")
        else
          room.speak("There was an error exiting pianobar")
        end
      when /^show\s(me\s)?the\scurrent\svolume(\slevel)/
        @piano
      when /^set\s(the\s)?(current\s)?volume\sto\s.+/
        @piano
      when /^mute\s(the\smusic)?/
        @piano
      when /^lower\s(the\s)?volume/
        @piano
      when /^raise\s(the\s)?volume/
        @piano
      when /^((tell\sme)|(what\sis))\sthe\s(current\s)?song(\sis)?/
        @piano
      when /^like\s(((the)|(this))\s)?(current\s)?song/
        @piano
      when /^dislike\s(((the)|(this))\s)?(current\s)?song/
        @piano
      end
    end
  end

end
