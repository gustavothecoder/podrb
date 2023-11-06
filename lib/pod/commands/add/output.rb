# frozen_string_literal: true

module Pod
  module Commands
    module Add
      class Output < ::Pod::Commands::BaseOutput
        def call
          case @context[:details]
          when :successfully_added
            <<~OUTPUT
              Podcast successfully added to the database!
            OUTPUT
          when :already_added
            <<~OUTPUT
              Podcast already exists in the database.
            OUTPUT
          when :badly_formatted
            <<~OUTPUT
              The podcast feed is badly formatted or unsupported.
            OUTPUT
          when :missing_sync_url
            <<~OUTPUT
              This podcast feed doesn't provide a sync url. Please, use the --sync-url option to set this data manually.
              Ex: `pod add FEED --sync-url=SYNC_URL`
            OUTPUT
          end
        end
      end
    end
  end
end
