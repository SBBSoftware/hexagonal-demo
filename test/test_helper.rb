# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
require 'rails/test_help'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

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
