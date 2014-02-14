require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    where_string = params.map { |param, _| "#{param} = ?" }
    where_string = where_string.join(' AND ')
    where_query = <<-SQL
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        #{where_string}
    SQL
    results = DBConnection.execute(where_query, *params.values)
    self.parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
