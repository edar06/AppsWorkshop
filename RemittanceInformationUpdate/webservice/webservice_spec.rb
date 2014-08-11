require File.dirname(__FILE__) + '/webservice.rb'
require 'rack/test'
require "json_spec"

set :environment, :test

def app 
	Sinatra::Application
end

describe 'Get Type of Environments' do
	include Rack::Test::Methods

	it 'Post Call Type of Environments is working' do
		post '/gettypeofenvironments'
		last_response.should be_ok
	end

	it 'Get Type of Environments JSON Structure' do
		response = post '/gettypeofenvironments'

		response.body.should_not be_empty
		response.body.should_not be_nil
		
		response_hash = JSON.parse(response.body)
		response_json = response.body
	
		if response_hash.key?("environmentTypes")

			response.body.should have_json_path("environmentTypes")
			response.body.should have_json_type(Array).at_path("environmentTypes")

			response.body.should have_json_path("environmentTypes/0/environmentTypeId")
			response.body.should have_json_type(String).at_path("environmentTypes/0/environmentTypeId")

			response.body.should have_json_path("environmentTypes/0/environmentType")
			response.body.should have_json_type(String).at_path("environmentTypes/0/environmentType")

		else

			response.body.should have_json_path("error")
			response.body.should have_json_type(String).at_path("error")
		end
	end

	it 'Get Type of Environments Something is Wrong' do
		response = post '/gettypeofenvironments'

		response.body.should_not be_empty
		response.body.should_not be_nil
		response.body.should_not have_json_path("error")
	end

end


describe 'Get Environments' do
	include Rack::Test::Methods

	it 'Post Call Get Environments is working' do
		params = {"environmentTypeId" => 1}
		post '/getenvironments', params.to_json
		last_response.should be_ok
	end

	it 'Get Environments JSON Structure' do
		params = {"environmentTypeId" => 1}
		response = post '/getenvironments', params.to_json

		response.body.should_not be_empty
		response.body.should_not be_nil
		
		response_hash = JSON.parse(response.body)
		response_json = response.body
	
		if response_hash.key?("environments")

			response.body.should have_json_path("environments")
			response.body.should have_json_type(Array).at_path("environments")
			
			response.body.should have_json_path("environments/0/environmentId")
			response.body.should have_json_type(String).at_path("environments/0/environmentId")

			response.body.should have_json_path("environments/0/environmentName")
			response.body.should have_json_type(String).at_path("environments/0/environmentName")

			response.body.should have_json_path("environments/0/environmentTypeId")
			response.body.should have_json_type(String).at_path("environments/0/environmentTypeId")

		else

			response.body.should have_json_path("error")
			response.body.should have_json_type(String).at_path("error")
		end
	end

	it 'Get Environments Error wrong Params' do
		params = {"environmentTypeIdz" => 1}
		response = post '/getenvironments', params.to_json

		response.body.should_not be_empty
		response.body.should_not be_nil
		response.body.should have_json_path("error")
		response.body.should have_json_type(String).at_path("error")
	end

	it 'Get Environments Something is Wrong' do
		params = {"environmentTypeId" => 1}
		response = post '/getenvironments', params.to_json

		response.body.should_not be_empty
		response.body.should_not be_nil
		response.body.should_not have_json_path("error")
	end

end

describe 'Get Type of Search' do
	include Rack::Test::Methods

	it 'Post Call Type of Search is working' do
		post '/gettypeofsearch'
		last_response.should be_ok
	end

	it 'Get Type of Search JSON Structure' do
		response = post '/gettypeofsearch'

		response.body.should_not be_empty
		response.body.should_not be_nil
		
		response_hash = JSON.parse(response.body)
		response_json = response.body
	
		if response_hash.key?("searchTypes")

			response.body.should have_json_path("searchTypes")
			response.body.should have_json_type(Array).at_path("searchTypes")

			response.body.should have_json_path("searchTypes/0/searchTypeId")
			response.body.should have_json_type(String).at_path("searchTypes/0/searchTypeId")

			response.body.should have_json_path("searchTypes/0/searchType")
			response.body.should have_json_type(String).at_path("searchTypes/0/searchType")

		else

			response.body.should have_json_path("error")
			response.body.should have_json_type(String).at_path("error")
		end
	end

	it 'Get Type of Search Something is Wrong' do
		response = post '/gettypeofsearch'

		response.body.should_not be_empty
		response.body.should_not be_nil
		response.body.should_not have_json_path("error")
	end

end

describe 'Get Search Results' do
	include Rack::Test::Methods

	it 'Post Call Search Results is working' do
		params = {"environmentId" => "BCE564C8-BB38-4979-B0F9-FCE9375FCADC", "searchTypeId" => 1, "searchStr" => ["12245"]}
		post '/getsearchresults', params.to_json
		last_response.should be_ok
	end

	it 'Get Search Results JSON Structure' do
		params = {"environmentId" => "BCE564C8-BB38-4979-B0F9-FCE9375FCADC", "searchTypeId" => 1, "searchStr" => ["12245"]}
		response = post '/getsearchresults', params.to_json

		response.body.should_not be_empty
		response.body.should_not be_nil
		
		response_hash = JSON.parse(response.body)
		response_json = response.body
	
		if response_hash.key?("searchResults")

			response.body.should have_json_path("environmentName")
			response.body.should have_json_type(String).at_path("environmentName")

			response.body.should have_json_path("searchStr")
			response.body.should have_json_type(Array).at_path("searchStr")

			response.body.should have_json_path("searchResults")
			response.body.should have_json_type(Array).at_path("searchResults")

			#FB, Invoice, Check Response Structure
			response.body.should have_json_path("searchResults/0/objectId")
			response.body.should have_json_type(String).at_path("searchResults/0/objectId")

			response.body.should have_json_path("searchResults/0/typeObjectId")
			response.body.should have_json_type(String).at_path("searchResults/0/typeObjectId")

			response.body.should have_json_path("searchResults/0/parentId")
			response.body.should have_json_type(String).at_path("searchResults/0/parentId")

			response.body.should have_json_path("searchResults/0/objectKey")
			response.body.should have_json_type(String).at_path("searchResults/0/objectKey")

			response.body.should have_json_path("searchResults/0/vendorName")
			response.body.should have_json_type(String).at_path("searchResults/0/vendorName")

			response.body.should have_json_path("searchResults/0/SCAC")
			response.body.should have_json_type(String).at_path("searchResults/0/SCAC")

			response.body.should have_json_path("searchResults/0/billedAmount")
			response.body.should have_json_type(String).at_path("searchResults/0/billedAmount")

			response.body.should have_json_path("searchResults/0/adjustedAmount")
			response.body.should have_json_type(String).at_path("searchResults/0/adjustedAmount")

			response.body.should have_json_path("searchResults/0/approvedAmount")
			response.body.should have_json_type(String).at_path("searchResults/0/approvedAmount")

			response.body.should have_json_path("searchResults/0/paidAmount")
			response.body.should have_json_type(String).at_path("searchResults/0/paidAmount")

			response.body.should have_json_path("searchResults/0/currency")
			response.body.should have_json_type(String).at_path("searchResults/0/currency")

			response.body.should have_json_path("searchResults/0/count")
			response.body.should have_json_type(Integer).at_path("searchResults/0/count")

			response.body.should have_json_path("searchResults/0/status")
			response.body.should have_json_type(String).at_path("searchResults/0/status")

			response.body.should have_json_path("searchResults/0/receivedDate")
			response.body.should have_json_type(String).at_path("searchResults/0/receivedDate")

			response.body.should have_json_path("searchResults/0/dueDate")
			response.body.should have_json_type(String).at_path("searchResults/0/dueDate")

			response.body.should have_json_path("searchResults/0/commentsCount")
			response.body.should have_json_type(Integer).at_path("searchResults/0/commentsCount")

			response.body.should have_json_path("searchResults/0/actions")
			response.body.should have_json_type(Array).at_path("searchResults/0/actions")

			response.body.should have_json_path("searchResults/0/searchById")
			response.body.should have_json_type(String).at_path("searchResults/0/searchById")

		else

			response.body.should have_json_path("error")
			response.body.should have_json_type(String).at_path("error")
		end
	end

	it 'Get Search Results Error wrong Params' do
		params = {"environmentIdz" => "BCE564C8-BB38-4979-B0F9-FCE9375FCADC", "searchTypeId" => 1, "searchStr" => ["12245"]}
		response = post '/getsearchresults', params.to_json

		response.body.should_not be_empty
		response.body.should_not be_nil
		response.body.should have_json_path("error")
		response.body.should have_json_type(String).at_path("error")
	end

	it 'Get Search Results Something is Wrong' do
		params = {"environmentId" => "BCE564C8-BB38-4979-B0F9-FCE9375FCADC", "searchTypeId" => 1, "searchStr" => ["12245"]}
		response = post '/getsearchresults', params.to_json

		response.body.should_not be_empty
		response.body.should_not be_nil
		response.body.should_not have_json_path("error")
	end

end
