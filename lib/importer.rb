module Importer
  class Base
    autoload :Callbacks, 'importer/callbacks'
    
    Base.class_eval do
      extend Callbacks
    end
    
    attr_accessor :object, :data

    def initialize(data)
      @data   = data
      @object = initialize_object
    end

    def run
      return false if before_import === false
      methods_to_run.each { |m| run_method(m) }
      save_object
      after_import
    end

    protected
      def methods_to_run
        public_instance_methods.select { |m| m =~ /^assign_/ }
      end
  
      def get(key)
        @data[key]
      end
      alias_method :g, :get

      def before_import
        true
      end
  
      def save_object
        object.save
      end
      
      def after_import
        true
      end
    
      def run_method(method)
        self.send(method)
      end
  end
end