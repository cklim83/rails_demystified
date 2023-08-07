class BaseModel
  attr_reader :errors

  def self.all
    record_hashes = connection.execute "SELECT * FROM #{table_name}"
    record_hashes.map do |record_hash|
      new(record_hash)
    end
  end

  def self.find(id)
    record_hash = connection.execute("SELECT * FROM #{table_name} WHERE #{table_name}.id = ? LIMIT 1", id).first
    new(record_hash)
  end

  def self.table_name
    self.to_s.pluralize.downcase
  end

  def destroy
    connection.execute "DELETE FROM #{self.class.table_name} WHERE #{self.class.table_name}.id = ?", id
  end

  def new_record?
    @id.nil?
  end

  def save
    return false unless valid?
    if new_record?
      insert
    else
      update
    end

    true
  end

  # Define a private class method 
  private_class_method def self.connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.execute "PRAGMA FOREIGN_KEYS = ON"  # Enforce foreign key and cascade constraints
    db_connection.results_as_hash = true
    db_connection
  end

  private

  def connection
    # https://stackoverflow.com/questions/20674/is-there-a-way-to-call-a-private-class-method-from-an-instance-in-ruby
    self.class.send :connection
  end
end
