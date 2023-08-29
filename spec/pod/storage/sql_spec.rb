# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Storage::SQL do
  describe "#execute" do
    context "when a valid DDL statement is passed" do
      it "executes the statement and returns true" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)

        result = db.execute <<-SQL
          create table podcasts (
            id int primary key,
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL

        expect(result).to eq(true)
      end
    end

    context "when a invalid DDL statement is passed" do
      it "doesn't executes the statement and raises an exception" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        statement = <<-SQL
          create table (
            id int primary key,
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL

        expect { db.execute(statement) }.to raise_error(Pod::Storage::Exceptions::WrongSyntax)
      end
    end
  end
end
