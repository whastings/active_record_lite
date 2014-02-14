require_relative '04_associatable'

# Phase V
module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      association_query = <<-SQL
        SELECT
          source_table.*
        FROM
          #{through_options.table_name} AS through_table
        INNER JOIN
          #{source_options.table_name} AS source_table
        ON
          through_table.#{source_options.foreign_key}
          = source_table.#{source_options.primary_key}
        WHERE
          through_table.#{through_options.primary_key}
          = ?
      SQL
      through_id = self.send(through_options.foreign_key)
      results = DBConnection.execute(association_query, through_id)
      source_options.model_class.parse_all(results).first
    end
  end
end
