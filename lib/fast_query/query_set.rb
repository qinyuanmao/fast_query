module FastQuery
  class QuerySet
    attr_reader :set

    def initialize(&block)
      @set = {}
      instance_eval(&block)
    end

    def conditions(group, *keys)
      options = if keys.size == 0
        I18n.t("query.#{group}")
      else
        keys.each_with_object({}) do |key, mono|
          mono[key] = I18n.t("query.#{group}.#{key}")
        end
      end
      options.map do |key, object|
        value = object.clone
        case value[:condition_type]
        when "options"
          value[:conditions] = value[:conditions][0].to_s.constantize.send(value[:conditions][1].to_s)
        when "search"
          value[:conditions] = value[:conditions][0].to_s.constantize.where(conditions[1].to_s).pluck(conditions[2].to_s, conditions[3].to_s)
        end
        value[:key] = key
        value
      end
    end

    def klass(group)
      @set[group].klass
    end

    def create_query(group, name)
      @set[group].create_query(name)
    end

    def exists_condition?(group, name)
      @set[group].set.has_key?(name)
    end

    def group(name, **options, &block)
      raise ArgumentError, "`name` can't be blank" if name.blank?
      raise ArgumentError, "must provide a block" unless block_given?

      if options[:class_name].present?
        klass = options[:class_name].to_s
      else
        klass = name.to_s.capitalize
      end
      @set[name] = Query.new(klass, &block)
    end
  end
end
