module ModelStubbing
  # Stubs hold custom attributes that are applied to models when
  # instantiated.  By default, accessing the same stub twice
  # will return the exact same instance.  However, custom attributes
  # will create unique stub instances.
  class Stub
    attr_reader :model, :attributes, :global_key, :name
    
    # Creates a new stub.  If it's not the default, it inherits the default 
    # stub's attributes.
    def initialize(model, name, attributes)
      @model      = model
      @name       = name
      @attributes = 
        if default? || model.default.nil?
          attributes
        else
          model.default.attributes.merge(attributes)
        end

      @global_key = (name == :default ? @model.singular : "#{name}_#{@model.singular}").to_sym
      @model.ordered_stubs << name
      @model.ordered_stubs.uniq!
      @model.all_stubs[@global_key] = @model.stubs[name] = self
    end
    
    def dup(model = nil)
      Stub.new(model || @model, @name, @attributes)
    end
    
    def ==(stub)
      (stub.object_id == object_id) ||
        (stub.is_a?(Stub) && stub.model.name == @model.name && stub.global_key == @global_key && stub.name == @name && stub.attributes == @attributes)
    end
    
    def default?
      @name == :default
    end
    
    # Retrieves or creates a record based on the stub's set attributes and the given custom attributes.
    # pass :id => :new to specify you want a new record, not one in the database
    def record(attributes = {})
      this_record_key = record_key(attributes)
      if attributes[:id] != :new && attributes[:id] != :dup && ModelStubbing.records.key?(this_record_key)
        ModelStubbing.records[this_record_key]
      else
        ModelStubbing.records[this_record_key] = instantiate(this_record_key, attributes)
      end
    end
    
    def inspect
      "(ModelStubbing::Stub(#{@name.inspect} => #{attributes.inspect}))"
    end
    
    def insert(attributes = {})
      @inserting = true
      object = record(attributes)
      object.new_record = true
      if model.options[:callbacks]
        object.save!
      elsif !model.options[:validate] || object.valid?
        connection.insert_fixture(object.stubbed_attributes, model.model_class.table_name)
      else
        raise "#{model.model_class}##{@name} data is not valid: #{object.errors.full_messages.to_sentence}"
      end
      @inserting = false
    end
    
    def with(attributes)
      @attributes.inject({}) do |attr, (key, value)|
        attr_value = attributes[key] || value
        attr_value = attr_value.record if attr_value.is_a?(Stub)
        attr.update key => attr_value
      end
    end
    
    def only(*keys)
      keys = Set.new Array(keys)
      @attributes.inject({}) do |attr, (key, value)|
        if keys.include?(key)
          attr.update key => (value.is_a?(Stub) ? value.record : value)
        else
          attr
        end
      end
    end
    
    def except(*keys)
      keys = Set.new Array(keys)
      @attributes.inject({}) do |attr, (key, value)|
        if keys.include?(key)
          attr
        else
          attr.update key => (value.is_a?(Stub) ? value.record : value)
        end
      end
    end
    
    def connection
      @connection ||= @model.connection
    end
  
  private
    def instantiate(this_record_key, attributes)
      case attributes[:id] 
        when :new
          is_new_record = true
          attributes.delete(:id)
        when :dup
          attributes[:id] = @model.model_class.base_class.mock_id
      end

      stubbed_attributes = stubbed_attributes(@attributes.merge(attributes))

      record = @model.model_class.new
      meta   = class << record
        attr_accessor :stubbed_attributes
        attr_writer   :new_record
        self
      end

      if is_new_record
        record.new_record = true
      else
        record.new_record = false
        record.id = ModelStubbing.record_ids[this_record_key] ||= attributes[:id] || @model.model_class.base_class.mock_id
      end
      record.stubbed_attributes = stubbed_attributes.merge(:id => record.id)
      stubbed_attributes.each do |key, value|
        meta.send :attr_accessor, key unless record.respond_to?("#{key}=")
        if value.is_a? Stub
          # set foreign key
          record.send("#{stubbed_attributes.column_name_for(key)}=", value.record.id)
          # set association
          record.send("#{key}=", value.record)
        elsif value.is_a? Array
          records = value.map { |v| v.is_a?(Stub) ? v.record : v }
          records.compact!

          # when assigning has_many instantiated stubs, temporarily act as new
          # otherwise AR inserts rows
          nr, record.new_record = record.new_record?, true
          record.send("#{key}=", records)
          record.new_record = nr
        else
          duped_value = case value
            when TrueClass, FalseClass, Fixnum, Float, NilClass, Symbol then value
            else value.dup
          end
          record.send("#{key}=", duped_value)
        end
      end
      record
    end
    
    def stubbed_attributes(attributes)
      attributes.inject FixtureHash.new(self) do |stubbed, (key, value)|
        stubbed.update key => value
      end
    end
    
    # so that duped stubs with duplicate attributes reuse the same record
    def record_key(attributes)
      return @record_key if @record_key && attributes.empty?
      key = [model.model_class.name, @global_key, @attributes.merge(attributes).inspect] * ":"
      @record_key = key if attributes.empty?
      key 
    end
  end
  
  class FixtureHash < Hash
    def initialize(stub)
      super()
      @stub = stub
    end

    def key_list
      keys.collect { |key| @stub.connection.quote_column_name(column_name_for(key)) } * ", "
    end

    def value_list
      list = inject([]) do |fixtures, (key, value)|
        column_name = column_name_for key
        column      = column_for column_name
        value       = value.record.id if value.is_a?(Stub)
        quoted      = @stub.connection ? @stub.connection.quote(value, column) : %("#{value.to_s}")
        fixtures << quoted.gsub('[^\]\\n', "\n").gsub('[^\]\\r', "\r")
      end.join(", ")
    end

    def column_name_for(key)
      (@keys ||= {})[key] ||= begin
        value = self[key]
        if value.is_a? Stub
          if defined?(ActiveRecord)
            if reflection = model_class.reflect_on_association(key)
              reflection.primary_key_name
            else
              raise "No reflection '#{key}' found for #{model_class.name} while guessing column_name"
            end
          else
            "#{key}_id"
          end
        else
          key
        end
      end
    end
  
    def column_for(name)
      model_class.columns_hash[name] if defined?(ActiveRecord) && model_class.ancestors.include?(ActiveRecord::Base)
    end
  
  private
    def model_class
      @stub.model.model_class
    end
  end
end