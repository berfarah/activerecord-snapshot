require "test_helper"
require "minitest/spec"

module ActiveRecord::Snapshot
  class FilterTablesTest < ActiveSupport::TestCase
    extend MiniTest::Spec::DSL

    describe "::call" do
      subject { FilterTables }
      let(:sql_dump) { Tempfile.new }
      let(:tempdir) { Dir.mktmpdir }

      before do
        ActiveRecord::Snapshot.config.store.stubs(tmp: Pathname.new(tempdir))
        File.write(sql_dump.path, file_fixture('example_dump.sql').read)
      end

      after do
        sql_dump.unlink
        FileUtils.rm_rf(tempdir)
      end

      describe "::call" do
        it "removes unwanted table from a SQL dump" do
          subject.call(tables: %w[advisors], sql_dump: sql_dump.path)
          assert_equal file_fixture('filtered_dump.sql').read, sql_dump.read
        end
      end
    end
  end
end
