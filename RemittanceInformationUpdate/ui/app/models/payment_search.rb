class PaymentSearch
  include ApplicationHelper

  def self.get_search_types
    search = PaymentSearch.new
    parameter = search.get_search_types_parameter
    response = ApplicationHelper.make_call_get(parameter)
  end 

  def get_search_types_parameter
    parameter = "gettypeofsearch"
  end

  def self.get_environment_types
    search = PaymentSearch.new
    parameter = search.get_environment_types_parameter
    response = ApplicationHelper.make_call_get(parameter)
  end

  def get_environment_types_parameter
    parameter = "gettypeofenvironments"
  end

  def self.get_environments(type)
    search = PaymentSearch.new
    parameter = search.get_environments_parameter
    hash = search.get_environments_json(type)
    response = ApplicationHelper.make_call_post(parameter, hash)
  end

  def get_environments_parameter
    parameter = "getenvironments"
  end

  def get_environments_json(type)
    hash = {
      "environmentTypeId" => type
    }
  end

  def self.get_search_results(params)
    search = PaymentSearch.new
    parameter = search.get_search_results_parameter
    hash = search.get_search_results_json(params)
    response = ApplicationHelper.make_call_post(parameter, hash)
    response = search.normalize_search_results(response) if !response["error"].present?
    response = search.order_search_result_by_status(response, params) if !response["error"].present?
    response
  end

  def get_search_results_parameter
    parameter = "getsearchresults"
  end

  def get_search_results_json(params)
    hash = {
      "environmentId" => params["environment_id"],
      "searchTypeId" => params["search_type_id"],
      "searchStr" => params["search_text"].strip.split(/\n/)
    }
  end

  def order_search_result_by_status(search_results, params)
    results_hash = {
      "environmentId" => search_results["environmentId"],
      "searchStr" => search_results["searchStr"],
      "searchById" => params["search_type_id"],
      "searchResults" => {} 
    }
    search_results["searchResults"].each do |x|
      status = x["status"]
      (results_hash["searchResults"][status] ||= []) << x
    end
    results_hash
  end

  def normalize_search_results(search_results)
    search_results["searchResults"].each do |x|
      if x["inPaymentDate"].present? 
        x["inPaymentDate"] = DateTime.parse("#{x["inPaymentDate"]}").strftime('%m/%d/%Y') 
      else 
        x["inPaymentDate"] = "N/A" 
      end

      if x["dueDate"].present? 
        x["dueDate"] = DateTime.parse("#{x["dueDate"]}").strftime('%m/%d/%Y') 
      else 
        x["dueDate"] = "N/A" 
      end

      if x["receivedDate"].present? 
        x["receivedDate"] = DateTime.parse("#{x["receivedDate"]}").strftime('%m/%d/%Y') 
      else 
        x["receivedDate"] = "N/A" 
      end

      if x["paidDate"].present? 
        x["paidDate"] = DateTime.parse("#{x["paidDate"]}").strftime('%m/%d/%Y') 
      else 
        x["paidDate"] = "N/A" 
      end

      x["billedAmount"] = "0.00" if !x["billedAmount"].present?
      x["adjustedAmount"] = "0.00" if !x["adjustedAmount"].present?
      x["approvedAmount"] = "0.00" if !x["approvedAmount"].present?
      x["paidAmount"] = "0.00" if !x["paidAmount"].present?
    end
    search_results
  end

end
