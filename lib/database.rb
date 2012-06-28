#encoding: utf-8
require_relative 'migrations'

class Database
  def initialize
    dbpath = File.dirname(__FILE__)+"/../articles.db"
    @db = SQLite3::Database.new dbpath
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      encoding: 'utf-8',
      database: dbpath,
      timeout: 1000
    )
    require_relative 'models'
    migrate!
  end

  def migrate!
    AddTables.migrate :up unless Category.table_exists?
  end

  def reset!
    AddTables.migrate :down
  end
end