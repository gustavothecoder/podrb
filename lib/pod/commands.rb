# frozen_string_literal: true

require_relative "commands/base"
require_relative "commands/init"
require_relative "commands/add"
require_relative "commands/podcasts"
require_relative "commands/episodes"
require_relative "commands/open"
require_relative "commands/archive"
require_relative "commands/dearchive"
require_relative "commands/delete"
require_relative "commands/sync"
require_relative "commands/update"

module Pod
  module Commands; end
end
