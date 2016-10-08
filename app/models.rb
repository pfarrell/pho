require 'sequel'
require 'pg'
require 'logger'
require 'rmagick'
require 'base64'
require 'json'

$console = ENV['RACK_ENV'] == 'development' ? Logger.new(STDOUT) : nil
DB = Sequel.connect(
  ENV['PHO_DB'] || 'postgres://localhost/pho',
  logger: $console,
  test: true
)

DB.sql_log_level = :debug
DB.extension(:pagination)
DB.extension(:pg_array, :pg_json)
DB.extension(:connection_validator)

DB.pool.connection_validation_timeout = 300

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

require 'models/camera'
require 'models/file'
require 'models/photo'
require 'models/tag'
require 'models/user'
