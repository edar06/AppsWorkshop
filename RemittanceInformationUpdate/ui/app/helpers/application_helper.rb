module ApplicationHelper

  def self.make_call_post(parameter, json)
    server = URI.encode(set_webservice_to_connect + parameter)
    begin
      request = RestClient.post(server, json.to_json, :content_type => :json, :accept => :json, :timeout => 60, :open_timeout => 60)
      ActiveSupport::JSON.decode request
    rescue => ex
      request = {
        "error" => ex.message
      }
    end
  end

  def self.make_call_get(parameter)
    url = URI.encode(set_webservice_to_connect + parameter)
    begin
      request = RestClient::Request.execute(:method => :get, :url => url, :timeout => 60, :open_timeout => 60)
      ActiveSupport::JSON.decode request
    rescue => ex
      request = {
        "error" => ex.message
      }
    end
  end

  def self.set_webservice_to_connect
    server = "https://payment-ops-websvc-dev.s03.filex.com/"
    server = "localhost:4567/"
  end

end
