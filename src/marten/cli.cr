require "colorize"
require "ecr"
require "option_parser"

require "./db/migration"
require "./db/management/constraint/**"
require "./db/management/index"
require "./db/management/migrations"
require "./migration"

require "./cli/**"

module Marten
  module CLI
    DEFAULT_COMMAND_NAME = "marten"

    def self.run(options = ARGV, name = DEFAULT_COMMAND_NAME)
      Manage.new(options: options, name: name).run
    end
  end
end
