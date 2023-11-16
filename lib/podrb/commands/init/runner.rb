# frozen_string_literal: true

require "fileutils"

module Podrb
  module Commands
    module Init
      class Runner < Podrb::Commands::BaseRunner
        def call
          return build_failure_response(details: :home_not_found) if home_dir.nil?

          return build_failure_response(details: :already_initialized) if Dir.exist?(podrb_config_dir)

          FileUtils.mkdir_p(podrb_config_dir)

          db = Infrastructure::Storage::SQL.new(db: podrb_db_dir)
          db.execute <<-SQL
            create table podcasts (
              id integer primary key,
              name text not null,
              description text,
              feed text not null unique,
              website text
            );
          SQL
          db.execute <<-SQL
            create table episodes (
              id integer primary key,
              title text not null,
              release_date text,
              duration text,
              link text not null,
              archived_at text,
              external_id string unique,
              podcast_id integer not null,
              foreign key(podcast_id) references podcasts(id)
            );
          SQL

          build_success_response(details: :successfully_initialized)
        rescue SystemCallError, Infrastructure::Storage::Exceptions::CantStartConnection
          build_failure_response(details: :cannot_create_initial_config)
        end
      end
    end
  end
end
