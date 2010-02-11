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

def stub_initial_api_request
  FakeWeb.register_uri :get, /#{KetchupAPI}\/profile.json$/,
    :response => %Q{HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Status: 200
X-Powered-By: Phusion Passenger (mod_rails/mod_rack) 2.2.5
X-Runtime: 106
ETag: "8d17ca017c14f427baabbd7881b7d82d"
Cache-Control: private, max-age=0, must-revalidate
Content-Length: 122
Server: nginx/0.6.35 + Phusion Passenger 2.2.5 (mod_rails/mod_rack)

{"name":"Ruby","timezone":"Melbourne","single_access_token":"y3chHxh9Qk1Drkg1j0Bw","email":"ketchup@freelancing-gods.com"}}
end
