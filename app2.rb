require 'sqlite3'

db = SQLite3::Database.new 'my_base.sqlite'
db.execute "INSERT INTO Cars (Name, Price) VALUES ('Mercedes', 15000)"
db.close
