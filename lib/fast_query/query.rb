module FastQuery
  class Query
    attr_accessor :target_class, :set

    def initialize(target_class, &block)
      @set = Hash.new
      @target_class = target_class
      instance_eval(&block)
    end

    def query(name, proc)
      @set[name] = proc
    end

    def create_query(name)
      @target_class.constantize.scope("with_#{name}".to_sym, @set[name])
    end
  end
end
