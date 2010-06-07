module Importer
  module Callbacks
    def assign(method, opts)
      @ordered_methods_to_run ||= []
    
      if before = opts[:before]
        add_method_before(method, before)
      elsif after = opts[:after]
        add_method_after(method, after)
      elsif between = opts[:between]
        add_method_between(method, between)
      else
        raise ArgumentError.new("Please specify :before, :after or :between")
      end
    end

    # Clears ordering of assigned methods
    def clear_ordered_assigns!
      @ordered_methods_to_run = []
    end

    private
      def add_method_before(method, before)
        if i = index_of_method(before)
          add_method_at_index(method, i)
        else
          add_method_at_index(method); add_method_at_index(before)
        end
      end
    
      def add_method_after(method, after)
        if i = index_of_method(after)
          add_method_at_index(method, i+1)
        else
          add_method_at_index(after); add_method_at_index(method)
        end
      end
    
      def add_method_between(method, between)
        if i = index_of_method(between.first)
          add_method_at_index(method, i+1)
        else
          add_method_at_index(between.first); add_method_at_index(method); add_method_at_index(between.last)
        end
      end
    
      def index_of_method(method)
        @ordered_methods_to_run.index(method)
      end
    
      def add_method_at_index(method_id, index=-1)
        @ordered_methods_to_run.insert(index, method_id)
      end
    end
end
