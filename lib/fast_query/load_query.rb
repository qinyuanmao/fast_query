module FastQuery
  module LoadQuery
    extend ActiveSupport::Concern
    class_methods do
      def load_query(group, **options)
        ApplicationController.before_action -> do
          @items = FastQuery.klass(group)
          params.each do |key, value|
            if FastQuery.exists_condition?(group, key) && value.present?
              FastQuery.create_query(group, key)
              @items = @items.send("with_#{key}", value, current_user)
            end
          end
        end, **options
      end
    end
  end
end
