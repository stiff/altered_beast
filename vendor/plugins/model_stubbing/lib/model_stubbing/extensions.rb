# Attempts to work around rails fixture loading
module ModelStubbing
  module Extension
    def self.included(base)
      class << base
        attr_accessor :definition, :definition_inserted
      end
      base.extend ClassMethods
      
      if base.respond_to?(:prepend_after)
        base.prepend_after(:all) do
          if self.class.definition_inserted
            self.class.definition.teardown!
            self.class.definition_inserted = false
          end
        end
      end
    end

    module ClassMethods
      def create_model_methods_for(models)
        class_eval models.collect { |model| model.stub_method_definition }.join("\n")
      end
    end

    def database?
      defined?(ActiveRecord)
    end
    
    def setup_fixtures
      ModelStubbing.records.clear
      if self.class.definition
        unless self.class.definition_inserted
          self.class.definition.insert!
          self.class.definition_inserted = true
        end
        self.class.definition.setup_test_run
      end
      if database?
        ActiveRecord::Base.connection.increment_open_transactions
        ActiveRecord::Base.connection.begin_db_transaction
      end
    end

    def teardown_fixtures
      if self.class.definition 
        self.class.definition.teardown_test_run
      end
      if database?
        ActiveRecord::Base.connection.rollback_db_transaction
        ActiveRecord::Base.connection.decrement_open_transactions
        ActiveRecord::Base.verify_active_connections!
      end
    end

    def stubs(key)
      self.class.definition && self.class.definition.stubs[key]
    end

    def current_time
      self.class.definition && self.class.definition.current_time
    end
  end
end
