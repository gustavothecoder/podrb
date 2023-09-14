# frozen_string_literal: true

require "sqlite3"

module Pod
  module Storage
    class SQL
      def initialize(db:)
        @conn = SQLite3::Database.new(db)
      rescue SQLite3::CantOpenException
        raise Exceptions::CantStartConnection
      end

      def execute(sql)
        result = @conn.execute(sql)

        # SQLite3 #execute always return an Array when the
        # statement was successfully executed, and sometimes,
        # the array will be empty, which isn't useful for us.
        result.empty? ? true : result
      rescue SQLite3::SQLException => exc
        raise Exceptions::WrongSyntax, exc.message
      end

      def query(sql)
        result = @conn.query(sql)
        parsed_result = result.to_a
        # From the SQLite3 doc: You must be sure to call close on the ResultSet instance that is
        # returned, or you could have problems with locks on the table. If called with a block,
        # close will be invoked implicitly when the block terminates.
        result.close
        parsed_result
      rescue SQLite3::SQLException => exc
        raise Exceptions::WrongSyntax, exc.message
      end
    end

    module Exceptions
      class Exception < ::StandardError; end

      class CantStartConnection < Exception; end

      class WrongSyntax < Exception; end
    end
  end
end
