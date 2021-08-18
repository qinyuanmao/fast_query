# frozen_string_literal: true

require_relative "fast_query/query_set"
require_relative "fast_query/query"
require_relative "fast_query/load_query"

module FastQuery
  class << self
    attr_reader :query_set

    def init_query(&block)
      @query_set = QuerySet.new(&block)
    end

    def query_set(group, *keys)
      @query_set.conditions(group, *keys)
    end

    def klass(group)
      @query_set.klass(group)
    end

    def exists_condition?(group, name)
      @query_set.exists_condition?(group, name.to_sym)
    end

    def create_query(group, name)
      @query_set.create_query(group, name.to_sym)
    end
  end
end
