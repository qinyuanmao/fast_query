module FastQuery
  class Query
    attr_accessor :klass, :set

    def initialize(klass, &block)
      @set = Hash.new
      @klass = klass.constantize
      instance_eval(&block)
    end

    def query(name, proc)
      @set[name] = proc
    end

    def create_query(name)
      @klass.scope("with_#{name}".to_sym, @set[name])
    end
  end
end
