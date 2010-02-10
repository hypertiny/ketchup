$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ketchup'
require 'fakeweb'
require 'spec'
require 'spec/autorun'

FakeWeb.allow_net_connect = false
KetchupAPI = 'useketchup.com/api/v1'

Spec::Runner.configure do |config|
  #
end
