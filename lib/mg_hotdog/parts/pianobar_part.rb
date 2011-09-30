class PianobarPart
  require 'pianobar-connector'

  def process(message, room)
    if message =~ /mg_hotdog[,\s]{1,2}/
      command = message.gsub(/mg_hotdog[,\s]{1,2}/,'')
      case command
      when /^play\s(some\s)?music/i
        @music_session = Pianobar::Session.new(
      when /^list\s([Pp](ianobar|andora)\s)?[Ss]tations/

      when /^(play|select)\s([Ss]tation\s)?.+/

      when /^pause\s(the\s)?music/i

      when /^(make|create)\s(a\s)?new\s[Ss]tation\s(from|with|using)\s(artist|genre|song)\s.+/

      when /^show\sme\sthe\s(music\s)?commands/

      when /^stop\s(the\s)?music/i

      when /^show\s(me\s)?the\scurrent\svolume(\slevel)/

      when /^set\s(the\s)?(current\s)?volume\sto\s.+/

      when /^mute\s(the\smusic)?/

      when /^lower\s(the\s)?volume/

      when /^raise\s(the\s)?volume/

      end
    end
  end

end
