# frozen_string_literal: true

require_relative "commands/base_runner"
require_relative "commands/base_output"
require_relative "commands/add/runner"
require_relative "commands/add/output"
require_relative "commands/archive/runner"
require_relative "commands/archive/output"
require_relative "commands/dearchive/runner"
require_relative "commands/dearchive/output"

require_relative "commands/init"
require_relative "commands/podcasts"
require_relative "commands/episodes"
require_relative "commands/open"
require_relative "commands/delete"
require_relative "commands/sync"
require_relative "commands/update"

module Pod
  module Commands; end
end
