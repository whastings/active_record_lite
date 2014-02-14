require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def initialize(name, options = {})
    [:primary_key, :foreign_key, :class_name].each do |attribute|
      value = (options[attribute] || self.send("generate_#{attribute}"))
      self.send("#{attribute}=", value)
    end
  end

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end

  protected

  attr_accessor :association_name, :association_class_name

  private

  def generate_primary_key
    :id
  end

  def generate_foreign_key
    foreign_key_name = association_class_name.singularize.downcase
    "#{foreign_key_name}_id".to_sym
  end

  def generate_class_name
    association_name.to_s.singularize.camelcase
  end

end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    self.association_name = name
    self.association_class_name = name
    super
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.association_name = name
    self.association_class_name = self_class_name
    super(name, options)
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end
