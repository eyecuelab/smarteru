require 'rest-client'
require 'nori'
require 'nokogiri'

require 'smarteru/error'
require 'smarteru/client'
require 'smarteru/response'
require 'smarteru/resources/base'
require 'smarteru/resources/users'

module Smarteru
  API_HOST = 'api.smarteru.com'
  API_VERSION = 'apiv2'
end
