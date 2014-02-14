require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end
end

class SQLObject < MassObject
  def self.columns
    return @columns if @columns
    columns_query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        1
    SQL
    attributes = DBConnection.execute2(columns_query).first.map(&:to_sym)
    add_attribute_accessors(attributes)
    @columns = attributes
    attributes
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    return @table_name if @table_name
    @table_name = self.to_s.underscore.pluralize
  end

  def self.all
    all_query = <<-SQL
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL
    results = DBConnection.execute(all_query)
    self.parse_all(results)
  end

  def self.find(id)
    find_query = <<-SQL
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = ?
    SQL
    result = DBConnection.execute(find_query, id)
    self.parse_all(result).first
  end

  def attributes
    return @attributes if @attributes
    @attributes = {}
  end

  def insert
    column_names = self.attributes.keys.join(", ")
    question_marks = (['?'] * self.attributes.count).join(", ")
    insert_query = <<-SQL
      INSERT INTO
        #{table_name} (#{column_names})
      VALUES
        (#{question_marks})
    SQL
    DBConnection.execute(insert_query, *attribute_values.compact)
    self.id = DBConnection.last_insert_row_id
  end

  def initialize(params = {})
    columns = self.class.columns
    params.each do |name, value|
      name = name.to_sym
      unless columns.include?(name)
        raise ArgumentError, "Unknown attribute #{name} for #{self.class}"
      end
      self.send("#{name}=", value)
    end
  end

  def save
    self.id ? self.update : self.insert
  end

  def update
    columns = self.class.columns.dup
    columns.delete(:id)
    set_string = columns.map { |column| "#{column} = ?" }.join(', ')
    update_query = <<-SQL
      UPDATE
        #{table_name}
      SET
        #{set_string}
      WHERE
        id = ?
    SQL
    query_values = attribute_values
    query_id = query_values.shift
    DBConnection.execute(update_query, *query_values, query_id)
  end

  def attribute_values
    self.class.columns.map do |attribute|
      self.send(attribute)
    end
  end

  private

  def self.add_attribute_accessors(attributes)
    attributes.each do |attribute|
      define_method(attribute) do
        self.attributes[attribute]
      end
      define_method("#{attribute}=") do |value|
        self.attributes[attribute] = value
      end
    end
  end

  def table_name
    self.class.table_name
  end

end
