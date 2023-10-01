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
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL

        expect { db.execute(statement) }.to raise_error(Pod::Storage::Exceptions::WrongSyntax)
      end
    end

    context "when a DML statement is passed" do
      it "executes the statement and returns true" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL

        result = db.execute <<-SQL
          insert into podcasts
          (name, description, feed, website)
          values (
            "Podcast",
            "A really good podcast.",
            "https://www.podcast.com/feed.xml",
            "https://www.podcast.com"
          );
        SQL

        expect(result).to eq(true)
      end
    end

    context "when an invalid DML statement is passed" do
      it "doesn't execute the statement and raises an exception" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL
        invalid_dml_statement = <<-SQL
          insert into podcasts
          (invalid, description, feed, website)
          values (
            "Podcast",
            "A really good podcast.",
            "https://www.podcast.com/feed.xml",
            "https://www.podcast.com"
          );
        SQL

        expect {
          db.execute(invalid_dml_statement)
        }.to raise_error(Pod::Storage::Exceptions::WrongSyntax)
      end
    end

    context "when an DML statement is passed, but it vialates a constraint" do
      it "doesn't execute the statement and raises an exception" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null unique,
            website text
          );
        SQL
        constraint_violation = <<-SQL
          insert into podcasts
          (name, description, feed, website)
          values (
            "Podcast",
            "A really good podcast.",
            "https://www.podcast.com/feed.xml",
            "https://www.podcast.com"
          );
        SQL
        db.execute(constraint_violation)

        expect {
          db.execute(constraint_violation)
        }.to raise_error(Pod::Storage::Exceptions::ConstraintViolation)
      end
    end
  end

  describe "#query" do
    context "when a valid query statement is passed" do
      it "returns the query result" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL
        db.execute <<-SQL
          insert into podcasts
          (name, description, feed, website)
          values (
            "Podcast",
            "A really good podcast.",
            "https://www.podcast.com/feed.xml",
            "https://www.podcast.com"
          );
        SQL

        result = db.query <<-SQL
          select *
          from podcasts;
        SQL

        expect(result.size).to eq(1)
        expect(
          result.first
        ).to eq(
          "name" => "Podcast",
          "description" => "A really good podcast.",
          "feed" => "https://www.podcast.com/feed.xml",
          "website" => "https://www.podcast.com"
        )
      end
    end

    context "when entity parameter is used" do
      it "returns entity objects" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL
        db.execute <<-SQL
          insert into podcasts
          (name, description, feed, website)
          values (
            "Podcast",
            "A really good podcast.",
            "https://www.podcast.com/feed.xml",
            "https://www.podcast.com"
          );
        SQL

        query_sql = <<-SQL
          select *
          from podcasts;
        SQL
        result = db.query(query_sql, Pod::Entities::Podcast)

        expect(result.size).to eq(1)
        entity = result.first
        expect(entity).to be_a(Pod::Entities::Podcast)
        expect(entity.name).to eq("Podcast")
        expect(entity.description).to eq("A really good podcast.")
        expect(entity.feed).to eq("https://www.podcast.com/feed.xml")
        expect(entity.website).to eq("https://www.podcast.com")
      end
    end

    context "when an invalid query statement is passed" do
      it "doesn't execute the query and raises an exception" do
        FileUtils.mkdir_p(TestHelpers::Path.config_dir)
        db = described_class.new(db: TestHelpers::Path.db_dir)
        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL
        db.execute <<-SQL
          insert into podcasts
          (name, description, feed, website)
          values (
            "Podcast",
            "A really good podcast.",
            "https://www.podcast.com/feed.xml",
            "https://www.podcast.com"
          );
        SQL

        expect {
          db.query("select invalid from podcasts")
        }.to raise_error(Pod::Storage::Exceptions::WrongSyntax)
      end
    end
  end
end
