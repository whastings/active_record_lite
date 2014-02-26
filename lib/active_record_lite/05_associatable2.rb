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

  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      association_query = <<-SQL
        SELECT
          source_table.*
        FROM
          #{source_options.table_name} AS source_table
        INNER JOIN
          #{through_options.table_name} As through_table
        ON
          source_table.#{source_options.primary_key}
          = through_table.#{source_options.foreign_key}
        INNER JOIN
          #{table_name} AS self_table
        ON
          self_table.id = through_table.#{through_options.foreign_key}
        WHERE
          self_table.id = ?
        ORDER BY
          source_table.#{source_options.primary_key}
      SQL
      self_id = self.id
      results = DBConnection.execute(association_query, self_id)
      source_options.model_class.parse_all(results)
    end
  end

  def has_many_through_belongs(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      association_query = <<-SQL
        SELECT
          source_table.*
        FROM
          #{source_options.table_name} source_table
      SQL
    end
  end
end
