# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
# ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
require 'rails/test_help'
# require 'lib/mocks/mock_products_controller'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require 'minitest/autorun'
Shoulda.autoload_macros(Rails.root)
# remove this
# Minitest::Reporters.use! [Minitest::Reporters::RubyMineReporter.new]
Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]
module ActiveSupport
  class TestCase
    include FactoryGirl::Syntax::Methods
  end
end
