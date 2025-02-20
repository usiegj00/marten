require "./spec_helper"

for_mysql do
  describe Marten::DB::Connection::MySQL do
    describe "#distinct_clause_for" do
      it "returns the expected distinct clause if no column names are specified" do
        conn = Marten::DB::Connection.default
        conn.distinct_clause_for([] of String).should eq "DISTINCT"
      end

      it "raises NotImplementedError if column names are specified" do
        conn = Marten::DB::Connection.default
        expect_raises(NotImplementedError) { conn.distinct_clause_for(["foo"]) }
        expect_raises(NotImplementedError) { conn.distinct_clause_for(["foo", "bar"]) }
      end
    end

    describe "#quote" do
      it "produces expected quoted strings" do
        conn = Marten::DB::Connection.default
        conn.quote("column_name").should eq "`column_name`"
      end
    end

    describe "#introspector" do
      it "returns the expected introspector instance" do
        conn = Marten::DB::Connection.default
        conn.introspector.should be_a Marten::DB::Management::Introspector::MySQL
      end
    end

    describe "#left_operand_for" do
      it "returns the original id no matter the predicate" do
        conn = Marten::DB::Connection.default
        conn.left_operand_for("table.column", "contains").should eq "table.column"
        conn.left_operand_for("table.column", "istartswith").should eq "table.column"
      end
    end

    describe "#limit_value" do
      it "returns the passed value if it is not nil" do
        conn = Marten::DB::Connection.default
        conn.limit_value(123_456_789).should eq 123_456_789
      end

      it "returns 2**64 if the passed value is nil" do
        conn = Marten::DB::Connection.default
        conn.limit_value(nil).should eq 18_446_744_073_709_551_615_u64
      end
    end

    describe "#max_name_size" do
      it "returns the expected value" do
        conn = Marten::DB::Connection.default
        conn.max_name_size.should eq 64
      end
    end

    describe "#operator_for" do
      it "returns the expected operator for a contains predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("contains").should eq "LIKE BINARY %s"
      end

      it "returns the expected operator for an endswith predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("endswith").should eq "LIKE BINARY %s"
      end

      it "returns the expected operator for an exact predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("exact").should eq "= %s"
      end

      it "returns the expected operator for a gt predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("gt").should eq "> %s"
      end

      it "returns the expected operator for a gte predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("gte").should eq ">= %s"
      end

      it "returns the expected operator for an icontains predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("icontains").should eq "LIKE %s"
      end

      it "returns the expected operator for an iendswith predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("iendswith").should eq "LIKE %s"
      end

      it "returns the expected operator for an iexact predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("iexact").should eq "LIKE %s"
      end

      it "returns the expected operator for an istartswith predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("istartswith").should eq "LIKE %s"
      end

      it "returns the expected operator for a lt predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("lt").should eq "< %s"
      end

      it "returns the expected operator for a lte predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("lte").should eq "<= %s"
      end

      it "returns the expected operator for a startswith predicate" do
        conn = Marten::DB::Connection.default
        conn.operator_for("startswith").should eq "LIKE BINARY %s"
      end
    end

    describe "#parameter_id_for_ordered_argument" do
      it "returns the expected ordered argument identifier" do
        conn = Marten::DB::Connection.default
        conn.parameter_id_for_ordered_argument(1).should eq "?"
        conn.parameter_id_for_ordered_argument(2).should eq "?"
        conn.parameter_id_for_ordered_argument(3).should eq "?"
        conn.parameter_id_for_ordered_argument(10).should eq "?"
      end
    end

    describe "#quote_char" do
      it "returns the expected quote character" do
        conn = Marten::DB::Connection.default
        conn.quote_char.should eq '`'
      end
    end

    describe "#schema_editor" do
      it "returns the expected schema editor instance" do
        conn = Marten::DB::Connection.default
        conn.schema_editor.should be_a Marten::DB::Management::SchemaEditor::MySQL
      end
    end

    describe "#scheme" do
      it "returns the expected scheme" do
        conn = Marten::DB::Connection.default
        conn.scheme.should eq "mysql"
      end
    end
  end
end
