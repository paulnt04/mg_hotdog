class WelcomePart

  def initialize(db)
    @@db = db
    begin
      @@ignored_users = @@db.execute('select * from ignored_users').flatten
    rescue
      @@ignored_users = []
      @@db.execute('create table ignored_users (name varchar(255))')
    end
  end

  def process(message, robot)
    if message.type =~ /EnterMessage/ && message.user.name =~ /Paul Panarese/
      robot.speak("PABLO!!!!!")
    elsif message.type =~ /EnterMessage/ && !(@@ignored_users.include?(message.user.name))
      robot.speak("Welcome #{message.user.name}")
    end
    if message.body && message.body.match(/.*(fuck(\s)?|off(\s)?|mg_hotdog(\s)?|(go\sto\s)|hell(\s)?){3}.*/i) && !(@@ignored_users.include?(message.user.name))
      begin
        @@db.execute("insert into ignored_users values ('#{message.user.name}')")
        @@ignored_users << message.user.name
        robot.speak("I will no longer acknowledge when #{message.user.name} enters this room.")
      rescue
        robot.speak("I cannot do that at this time.")
        puts "ERROR::SQLite3, cannot write to db"
      end
    end
    if message.body && message.body.match(/please welcome me.+mg_hotdog/i) && @@ignored_users.include?(message.user.name)
      begin
        @@db.execute("delete from ignored_users where name=='#{message.user.name}'")
        @@ignored_users.delete_if{|user| user == message.user.name}
        robot.speak("I will now acknowledge when #{message.user.name} enters this room.")
      rescue
        robot.speak("I cannot do that at this time.")
        puts "ERROR::SQLite3, cannot write to db"
      end
    end
  end
end
