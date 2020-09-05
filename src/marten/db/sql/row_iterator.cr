module Marten
  module DB
    module SQL
      class RowIterator
        getter cursor

        def initialize(
          @model : Model.class,
          @result_set : ::DB::ResultSet,
          @joins : Array(Join),
          @cursor : Int32 = 0
        )
        end

        def advance
          # Here we perform a @result_set.read for each model field that should've been read as of for each possible
          # join. This is done to allow the next appropriate join relation to be read properly by the next row iterator
          # and to handle the case of null foreign keys for example.

          each_local_column { |rs, _c| rs.read(::DB::Any) }
          each_joined_relation { |ri, _c| ri.advance }
        end

        def each_local_column
          @model.fields.size.times do
            yield @result_set, @result_set.column_names[@cursor]
            @cursor += 1
          end
        end

        def each_joined_relation
          @joins.each do |join|
            relation_iterator = self.class.new(
              join.field.related_model,
              @result_set,
              join.children,
              @cursor
            )

            yield relation_iterator, join.field

            @cursor = relation_iterator.cursor
          end
        end
      end
    end
  end
end
