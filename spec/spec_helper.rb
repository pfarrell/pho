require 'simplecov'
require 'test/unit'
require 'rack/test'

SimpleCov.start do
  require 'simplecov-badge'
  add_filter "/vendor/"
  add_filter "/spec/"
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::BadgeFormatter,
    ]
  )
end

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

#  config.disable_monkey_patching!

  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true){ example.run }
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.include RSpecMixin
end
require './app'
