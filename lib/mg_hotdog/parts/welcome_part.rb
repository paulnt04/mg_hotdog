class WelcomePart

  def initialize(robot)
    begin
      @ignored_users = robot.database.select('*','ignored_users').flatten
    rescue
      @ignored_users = []
      robot.database.create_table('ignored_users',{'name' => 'varchar(255)'})
    end
  end

  def process(message, robot)
    if message.type =~ /EnterMessage/ && message.user.name =~ /Paul Panarese/
      robot.speak("PABLO!!!!!")
    elsif message.type =~ /EnterMessage/ && !(@ignored_users.include?(message.user.name))
      robot.speak("Welcome #{message.user.name}")
    elsif message.body && message.body.match(/^(fuck(ing)?(\s)?|off(\s)?|mg_hotdog(\s)?|(go\sto\s)|hell(\s)?|please(\s)?|stop\swelcoming\sme(\s)?){3,4}.*/i) && !(@ignored_users.include?(message.user.name))
      begin
        robot.database.insert("'#{message.user.name}'",'ignored_users')
        @ignored_users << message.user.name
        robot.speak("I will no longer acknowledge when #{message.user.name} enters this room.")
      rescue
        raise IOError.new('database connection')
      end
    elsif message.body && message.body.match(/^(fuck(ing)?(\s)?|off(\s)?|mg_hotdog(\s)?|(go\sto\s)|hell(\s)?|please(\s)?|stop\swelcoming\sme(\s)?){3,4}.*/i) && (@ignored_users.include?(message.user.name))
      if message.body.match(/hell/)
        robot.speak("Why don't you go to hell?")
      elsif message.body.match(/fuck\soff/)
        robot.speak("Fuck you too")
      else
        robot.speak("Fuck you")
      end
    elsif message.body && message.body.match(/^please welcome me.+mg_hotdog/i) && @ignored_users.include?(message.user.name)
      begin
        robot.database.delete("name='#{message.user.name}'",'ignored_users')
        @ignored_users.delete_if{|user| user == message.user.name}
        robot.speak("I will now acknowledge when #{message.user.name} enters this room.")
      rescue
        raise IOError.new('database connection')
      end
    end
  end
end
