module Marten
  module Handlers
    # Provides the ability to retrieve a list of model records.
    module RecordListing
      macro included
        # Returns the configured model class.
        class_getter model : DB::Model.class | Nil

        # Returns the name of the page number parameter.
        class_getter page_number_param : String = "page"

        # Returns the page size to use if records should be paginated.
        class_getter page_size : Int32 | Nil

        # Returns the array of fields to use to order the records.
        class_getter ordering : Array(String) | Nil

        extend Marten::Handlers::RecordListing::ClassMethods
      end

      module ClassMethods
        # Allows to configure the model class that should be used to retrieve the list record.
        def model(model : DB::Model.class | Nil)
          @@model = model
        end

        # Allows to configure the name of the page number parameter.
        def page_number_param(param : String | Symbol)
          @@page_number_param = param.to_s
        end

        # Allows to configure the page size to use if records should be paginated.
        #
        # If the specified page size is `nil`, it means that records won't be paginated.
        def page_size(page_size : Int32 | Nil)
          @@page_size = page_size
        end

        # Allows to configure the list of fields to use to order the records.
        def ordering(*fields : String | Symbol)
          @@ordering = fields.map(&.to_s).to_a
        end

        # Allows to configure the list of fields to use to order the records.
        def ordering(fields : Array(String | Symbol))
          @@ordering = fields.map(&.to_s)
        end
      end

      # Returns the model used to list the records.
      def model : Model.class
        self.class.model || raise Errors::ImproperlyConfigured.new(
          "'#{self.class.name}' must define a model class via the '::model' class method method or by overriding the " \
          "'#model' method"
        )
      end

      # Returns a page resulting from the pagination of the queryset for the current page.
      def paginate_queryset
        raw_page_number = params[self.class.page_number_param]? || request.query_params[self.class.page_number_param]?

        page_number = begin
          raw_page_number.as?(Int32 | String).try(&.to_i32) || 1
        rescue ArgumentError
          1
        end

        queryset.paginator(self.class.page_size.not_nil!).page(page_number)
      end

      # Returns the queryset used to retrieve the record displayed by the handler.
      def queryset
        if ordering = self.class.ordering
          model.all.order(ordering)
        else
          model.all
        end
      end
    end
  end
end
