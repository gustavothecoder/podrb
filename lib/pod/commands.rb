# frozen_string_literal: true

require_relative "commands/base_runner"
require_relative "commands/base_output"
require_relative "commands/add/runner"
require_relative "commands/add/output"
require_relative "commands/archive/runner"
require_relative "commands/archive/output"
require_relative "commands/dearchive/runner"
require_relative "commands/dearchive/output"
require_relative "commands/delete/runner"
require_relative "commands/delete/output"
require_relative "commands/episodes/runner"
require_relative "commands/episodes/output"
require_relative "commands/init/runner"
require_relative "commands/init/output"
require_relative "commands/open/runner"
require_relative "commands/open/output"
require_relative "commands/podcasts/runner"
require_relative "commands/podcasts/output"
require_relative "commands/sync/runner"
require_relative "commands/sync/output"

require_relative "commands/update"

module Pod
  module Commands; end
end
