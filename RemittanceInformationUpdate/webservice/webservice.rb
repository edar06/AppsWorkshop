require 'sinatra'
require 'sinatra/json'
require 'json'
require 'sinatra/reloader' if development?
require 'tiny_tds'

class PaymentOps < Sinatra::Base
  
  #Global Hash contains settings to connecto to the SQL Database.
  $db_config = {:host => 'GlobalSQL.Traxtech.com',
  	:database => 'GlobalPaymentsProd',
  	:username => 'PaymentOpsWeb',
  	:password => 'PaymentOps*Web',
  	:login_timeout => 5,
  	:timeout => 60}

  def self.create_tiny_tds
    tinytds_connection = TinyTds::Client.new ({ :host => $db_config[:host],
      :database => $db_config[:database],
      :username => $db_config[:username],
      :password => $db_config[:password],
      :login_timeout => $db_config[:login_timeout],
      :timeout => $db_config[:timeout] })
  end

  #Receives an array with the names of the fields that should have beeen part of the JSON Request and the actual JSON Request.
  #Iterates through the required fields and sends an hash back specifying if the required fields are all present and if not it will send back an error message.
  def self.check_required_fields(required, json_request)
    required.each do |r|
      if json_request[r] == nil
        return {:success => false, :error => "#{r} is a required parameter."}
      end
    end

    return {:success => true, :error => ''}
  end

  def self.execute_sql_query(query)
    begin
      tinytds_connection = create_tiny_tds
      sql_response = tinytds_connection.execute(query)
      sql_response_hash = {:success => true, :sql_response => Array.new}
      sql_response.each do |row|
        sql_response_hash[:sql_response] << row
      end
      if tinytds_connection.active?
        tinytds_connection.close
      end
    rescue => ex
      sql_response_hash = {:success => false, :error => "#{ex}"}
    end
    sql_response_hash
  end 

  def self.get_type_of_environments
  	json_response = get_type_of_environments_sql
  end
  
  def self.get_type_of_environments_sql
  	sql_query = "EXECUTE UI.GetTypeOfEnvironments"
  	sql_response_hash = execute_sql_query(sql_query)
  
  	if sql_response_hash[:success]
  		if sql_response_hash[:sql_response].count <= 0
  			json_response = {:error => "There are no type of environments available."}
  		else
  			json_response = get_type_of_environments_json(sql_response_hash[:sql_response])
  		end
  	else
  		json_response = {:error => "#{sql_response_hash[:error]}"}
  	end
  end
  
  def self.get_type_of_environments_json(type_of_environments)
  	type_env_array = Array.new
  	type_of_environments.each do |row|
  		type_env_array << {:environmentTypeId => "#{row["TypeOfEnvironmentId"]}", :environmentType => "#{row["Name"]}"}
  	end
  	type_env_json = {:environmentTypes => type_env_array}
  end
  
  #Manage the getenvironments request from the Client.
  def self.get_environments(json_request)
  	required = ["environmentTypeId"]
  	validity = check_required_fields(required, json_request)
  	if !validity[:success]
  		json_response = {:error => "#{validity[:error]}"}
  	else
  		json_response = get_environments_sql(json_request)
  	end
  
  	json_response
  end
  
  #Receives the JSON Request. Create a connection with the right SQL DB and fires the query to lookup all the PROD environments.
  #It gives an appropiate answer in JSON format either if no environments were found, if there was a problem with the connection, or a complete list of all the environmnets.
  def self.get_environments_sql(json_request)
  	sql_query = "EXECUTE UI.GetEnvironments #{json_request["environmentTypeId"]}"
  	sql_response_hash = execute_sql_query(sql_query)
  
  	if sql_response_hash[:success]
  		if sql_response_hash[:sql_response].count <= 0
  			json_response = {:error => "There are no environments available for the environment type selected."}
  		else
  			json_response = get_environments_json(sql_response_hash[:sql_response], json_request)
  		end
  	else
  		json_response = {:error => "#{sql_response_hash[:error]}"}
  	end
  end
  
  #Given the results from the SQL Query about the Trax Environments and the JSON Request. It will create the main JSON answer to give back to the Client.
  def self.get_environments_json(environments, json_request)
  	env_array = Array.new
  	environments.each do |row|
  		env_array << {:environmentId => "#{row["EnvironmentId"]}", :environmentName => "#{row["Name"]}", :environmentTypeId => "#{row["TypeOfEnvironmentId"]}"}
  	end
  	environments_json = {:environments => env_array}
  end
  
  #Manage the getenvironments request from the Client.
  def self.get_type_of_search()
  	json_response = get_type_of_search_sql()
  end
  
  #Receives the JSON Request. Create a connection with the right SQL DB and fires the query to lookup all the PROD environments.
  #It gives an appropiate answer in JSON format either if no environments were found, if there was a problem with the connection, or a complete list of all the environmnets.
  def self.get_type_of_search_sql()
  	sql_query = "EXECUTE UI.GetTypeOfObjects"
  	sql_response_hash = execute_sql_query(sql_query)
  
  	if sql_response_hash[:success]
  		if sql_response_hash[:sql_response].count <= 0
  			json_response = {:error => "There are no Search types available at this moment."}
  		else
  			json_response = get_type_of_search_json(sql_response_hash[:sql_response])
  		end
  	else
  		json_response = {:error => "#{sql_response_hash[:error]}"}
  	end
  end
  
  #Given the results from the SQL Query about the Trax Environments and the JSON Request. It will create the main JSON answer to give back to the Client.
  def self.get_type_of_search_json(search_types)
  	search_types_array = Array.new
  	search_types.each do |row|
  		search_types_array << {:searchTypeId => "#{row["TypeObjectId"]}", :searchType => "#{row["Name"]}"}
  	end
  	search_types_json = {:searchTypes => search_types_array}
  end
  
  #Manage the getenvironments request from the Client.
  def self.get_search_results(json_request)
  	required = ["environmentId", "searchTypeId", "searchStr"]
  	validity = check_required_fields(required, json_request)
  	if !validity[:success]
  		json_response = {:error => "#{validity[:error]}"}
  	else
  		json_response = get_search_results_sql(json_request)
  	end
  	json_response
  end
  
  #Receives the JSON Request. Create a connection with the right SQL DB and fires the query to lookup all the PROD environments.
  #It gives an appropiate answer in JSON format either if no environments were found, if there was a problem with the connection, or a complete list of all the environmnets.
  def self.get_search_results_sql(json_request)
  	search_string = json_request["searchStr"].join(",")
  	sql_query = "EXECUTE UI.GetSearchResults '#{json_request["environmentId"]}', #{json_request["searchTypeId"]}, '#{search_string}'"
  
  	sql_response_hash = execute_sql_query(sql_query)
  
  	if sql_response_hash[:success]
  		json_response = get_search_results_json(sql_response_hash[:sql_response], json_request)
  	else
  		json_response = {:error => "#{sql_response_hash[:error]}"}
  	end
    json_response
  end
  
  #Given the results from the SQL Query about the Trax Environments and the JSON Request. It will create the main JSON answer to give back to the Client.
  def self.get_search_results_json(search_results, json_request)
  	search_results_array = Array.new
  	search_results.each do |row|
  		search_results_array << 
  		{
  			:objectId => "#{row["ObjectId"]}", 
  			:typeObjectId => "#{row["TypeObjectId"]}",
  			:parentId => "#{row["ParentId"]}",
  			:objectKey => "#{row["ObjectKey"]}",
  			:vendorName => "#{row["VendorName"]}",
  			:SCAC => "#{row["SCAC"]}",
  			:billedAmount => "#{row["BilledAmount"]}",
  			:adjustedAmount => "#{row["AdjustedAmount"]}",
  			:approvedAmount => "#{row["ApprovedAmount"]}",
  			:paidAmount => "#{row["PaidAmount"]}",
  			:currency => "#{row["Currency"]}",
  			:count => row["Count"],
  			:status => "#{row["Status"]}",
  			:inPaymentDate => "#{row["InPaymentDate"]}",
  			:dueDate => "#{row["DueDate"]}",
        :receivedDate => "#{row["ReceivedDate"]}",
        :paidDate => "#{row["PaidDate"]}",
  			:commentsCount => row["CommentsCount"],
  			:actions => "#{row["Actions"]}",
  			:searchById => "#{row["SearchTextbyTypeObjectId"]}"
  		}
  	end
  	search_results_json = 
  	{:environmentId => json_request["environmentId"], :searchStr => json_request["searchStr"], :searchResults => search_results_array}
  end
  
 
end

#Requests the WebService can receive from a Client
get '/gettypeofenvironments' do
    json PaymentOps.get_type_of_environments()
end

post '/getenvironments' do
    json_request = JSON.parse(request.body.read)
    json PaymentOps.get_environments(json_request)
end

get '/gettypeofsearch' do
    json PaymentOps.get_type_of_search()
end

post '/getsearchresults' do
    json_request = JSON.parse(request.body.read)
    json PaymentOps.get_search_results(json_request)
end

get '/' do
    return 'Party Time!'
end

