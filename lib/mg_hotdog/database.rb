require 'sqlite3'

module MgHotdog
  class Database
    attr_accessor :connection
    def initialize(db_path)
      if db_path
        @connection = SQLite3::Database.open(db_path)
      else
        raise RuntimeError, 'Database path must be specified.'
      end
    end

    def create_table(table,columns = {})
      @connection.execute("create table #{table}(#{columns.collect{|column,type| "#{column.to_s} #{type.to_s}" }.join(', ')})")
    end

    def select(query,table)
      @connection.execute("select #{query} from #{table}")
    end

    def delete(query,table)
      @connection.execute("delete from #{table} where #{query}")
    end

    def insert(query,table)
      @connection.execute("insert into #{table} values(#{query})")
    end

    def execute(query)
      @connection.execute(query)
    end
  end
end
