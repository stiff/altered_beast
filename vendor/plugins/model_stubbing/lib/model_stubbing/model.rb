module ModelStubbing
  # Models hold one or more stubs.
  class Model
    attr_accessor :name, :plural, :singular
    attr_reader   :definition, :stubs, :model_class, :options, :ordered_stubs

    # Creates a stub for this model.  A stub with no name is assumed to be the default
    # stub.  A global key for the definition is also created based on the singular
    # form of the stub name.  
    def stub(name = nil, options = {})
      if name.is_a?(Hash)
        options = name
        name    = :default
      end

      Stub.new(self, name, options)
    end

    def initialize(definition, klass, options = {}, &block)
      @definition    = definition
      @model_class   = klass
      @name          = options.delete(:name)     || default_name.to_sym
      @plural        = options.delete(:plural)   || name
      @singular      = options.delete(:singular) || name.to_s.singularize
      @options       = options
      @stubs         = {}
      @ordered_stubs = []
      unless @model_class.respond_to?(:mock_id)
        class << @model_class
          define_method :mock_id do
            @mock_id ||= 9999
            @mock_id  += 1
          end
        end
      end
      instance_eval &block if block
    end

    def default_name
      name = @model_class.name
      if name.respond_to?(:underscore)
        name.underscore.pluralize.gsub(/\//, '_')
      else
        name.downcase.gsub(/::/, '_') << "s"
      end
    end
    
    def dup(definition = nil)
      copy = self.class.new(definition || @definition, @model_class, @options.merge(:name => @name, :plural => @plural, :singular => @singular))
      stubs.each do |key, value|
        copy.stubs[key] = value.dup(copy)
      end
      copy
    end
    
    def ==(model)
      (model.object_id == object_id) ||
        (model.is_a?(Model) && model.name == @name && model.model_class == @model_class)
    end
    
    # References the default stub for this model.
    def default
      @stubs[:default]
    end
    
    # Accesses the current mocked time for this definition.
    def current_time
      @definition.current_time
    end
    
    # Shortcut to all the stubs for the definition.
    def all_stubs(key = nil)
      key ? @definition.stubs[key] : @definition.stubs
    end

    # Instantiates a stub into a new record.
    def retrieve_record(key, attributes = {})
      unless fetch = @stubs[key]
        raise ActiveRecord::RecordNotFound, "Could not find the record defined by '#{key}'."
      end
      fetch.record(attributes)
    end
    
    def stub_method_definition
      <<-END
      def #{@plural}(key, attrs = {})
        klass = self.class
        unless defined?(klass.definition) and klass.definition
          # If we are in a subclass where define_models was called on a superclass but
          # not on this subclass (e.g. in a nested define block) then define_models
          # needs to be called again for this subclass in order for the teardown to
          # happen correctly.
          k = klass.superclass
          name = nil
          until k == Object or k.nil?
            if defined?(k.definition) and k.definition
              name = k.definition.name
              k = nil
            end
          end
          klass.module_eval { define_models name }
          unless klass.definition_inserted
            klass.definition.insert!
            # Don't want to set definition_inserted to true because it will
            # roll back at the end of the first test. The next test will
            # correctly insert again before the transaction begins.
          end
          klass.definition.setup_test_run
        end
        klass.definition.models[#{@plural.inspect}].retrieve_record(key, attrs)
      end
      def new_#{@singular}(key = :default, attrs = {})
        key, attrs = :default, key if key.is_a?(Hash)
        #{@plural}(key, attrs.merge(:id => :new))
      end
      def new_#{@singular}!(key = :default, attrs = {})
        key, attrs = :default, key if key.is_a?(Hash)
        #{@plural}(key, attrs.merge(:id => :dup))
      end
      def create_#{@singular}(key = :default, attrs = {})
        stub = new_#{@singular}(key, attrs)
        stub.save!
        stub
      end
      END
    end

    def inspect
      "(ModelStubbing::Model(#{@name.inspect} => [#{@stubs.keys.collect { |k| k.to_s }.sort.join(", ")}]))"
    end
    
    def insert
      purge
      @ordered_stubs.each do |name| 
        if stub = @stubs[name]
          stub.insert
        end
      end
    end
    
    def purge
      if connection
        connection.delete "DELETE FROM #{connection.quote_table_name(@model_class.table_name)}"
      end
    end
    
    def connection
      @connection ||= model_class.respond_to?(:connection) && model_class.connection
    end

  protected
    def method_missing(model_name, stub_name, *args)
      named_model = @definition.models[model_name]
      if named_model.nil?
        raise "No #{model_name.inspect} model found when calling #{model_name}(#{stub_name})"
      end
      stub = named_model.stubs[stub_name]
      if stub.nil?
        raise "No #{stub_name.inspect} stub found in the #{model_name.inspect} model when calling #{model_name}(#{stub_name})"
      else
        stub
      end
    end
  end
end
