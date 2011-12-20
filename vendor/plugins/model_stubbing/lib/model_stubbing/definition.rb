module ModelStubbing
  # A Definition holds an array of models with their own stubs.  Also, a definition
  # can set the current time for your tests.  You typically create one per test case or
  # rspec example.
  class Definition
    attr_writer :insert, :current_time
    attr_reader :models, :stubs, :ordered_models, :options, :name

    # Sets the time that Time.now is mocked to (in UTC)
    def time(*args)
      @current_time = Time.utc(*args)
    end
    
    def current_time
      @current_time ||= Time.now.utc
    end
    
    # Creates a new ModelStubbing::Model to hold one or more stubs.  Multiple calls will append
    # any added stubs to the same model instance.
    #
    # Options:
    # * :name      - The name used of the model.  Defaults to the "Foo".underscore.pluralize
    # * :plural    - The name of the method used to access the stubs in your test.  
    #                Defaults to #name.
    # * :singular  - The name of the method for the new_* stub accessors.
    # * :validate  - set to false if you don't want to validate model data, or run callbacks
    # * :callbacks - set to true if you want to run callbacks.
    def model(klass, options = {}, &block)
      m = Model.new(self, klass, @options.merge(options))
      @ordered_models <<  m unless @models.key?(m.name)
      @models[m.name] ||= m
      @models[m.name].instance_eval(&block) if block
      @models[m.name]
    end
    
    def initialize(name = nil, &block)
      @name           = name
      @ordered_models = []
      @models         = {}
      @stubs          = {}
      @options        = {}
      instance_eval &block if block
    end
    
    def dup
      copy = self.class.new
      copy.current_time = @current_time
      copy.options.update @options
      models.each do |name, model|
        copy.models[name] = model.dup(copy)
      end
      @ordered_models.each do |ordered|
        copy.ordered_models << copy.models[ordered.name]
      end
      stubs.each do |name, stub|
        copy.stubs[name] = copy.models[stub.model.name].stubs[stub.name]
      end
      copy
    end
    
    def ==(defn)
      (defn.object_id == object_id) ||
        (defn.is_a?(Definition) && defn.models == @models && defn.stubs == @stubs)
    end
    
    # Sets up the given class for this definition.  Adds a few helper methods:
    #
    # * #stubs: Lets you access all stubs with a global key, which combines the model
    #   name with the stub name.  stubs(:user) gets the default user stub, and stubs(:admin_user)
    #   gets the 'admin' user stub.
    #
    # * #current_time: Accesses the current mocked time for a test or spec.
    #
    # Shortcut methods for each model are generated as well.  users(:default) accesses
    # the default user stub, and users(:admin) accesses the 'admin' user stub.
    def setup_on(base, options = {}, &block)
      @options = {:validate => false, :insert => true}.update(options)
      self.insert = false if @options[:insert] == false
      self.instance_eval(&block) if block
      if base.ancestors.any? { |a| a.to_s == "Test::Unit::TestCase" || a.to_s == "Spec::Example::ExampleGroup" }
        unless base.ancestors.include?(ModelStubbing::Extension)
          base.send :include, ModelStubbing::Extension
        end
        base.definition = self
        base.create_model_methods_for models.values
      end
    end
    
    # Retrieves a record for a given stub.  The optional attributes hash let's you specify
    # custom attributes.  If no custom attributes are passed, then each call to the same
    # stub will return the same object.  Custom attributes result in a new instantiated object
    # each time.
    def retrieve_record(key, attributes = {})
      @stubs[key].record(attributes)
    end
    
    def insert?
      @insert != false && database?
    end
    
    def insert!
      return unless database? && insert?
      ActiveRecord::Base.transaction do
        ordered_models.each(&:insert)
      end
    end
    
    def teardown!
      return unless database? && insert?
      ActiveRecord::Base.transaction do
        ordered_models.each(&:purge)
      end
    end
    
    def setup_test_run
      ModelStubbing.records.clear
      ModelStubbing.stub_current_time_with(current_time) if current_time
    end
    
    def teardown_test_run
      ModelStubbing.records.clear
      # TODO: teardown Time.stubs(:now)
    end
    
    def database?
      defined?(ActiveRecord)
    end
    
    def inspect
      "(ModelStubbing::Definition(:models => [#{@models.keys.collect { |k| k.to_s }.sort.join(", ")}]))"
    end
  end
end
