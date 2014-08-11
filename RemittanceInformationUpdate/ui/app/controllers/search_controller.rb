class SearchController < ApplicationController
  def index
    @searchTypes = PaymentSearch.get_search_types()
    @environmentTypes = PaymentSearch.get_environment_types()
  end

  def get_environments
    env_id = params["id"]
    @environments = PaymentSearch.get_environments(env_id)
  end

  def get_search_results
    get_session_name
    @searchResults = PaymentSearch.get_search_results(params)
    if !@searchResults["error"]
      @searchResults["searchResults"].each do |k,v|
       @searchResults["searchResults"][k]  = Kaminari.paginate_array(v).page(params[:page]).per(10)
      end
      save_search_cache
    end
  end

  def navigate_search_results
    get_search_cache
    if @searchResults.present?
      @status = params[:status]
      @type = params[:type]
      load_page = params[:page]
      @page = @searchResults["searchResults"]["#{@status}"].page(load_page)
      save_search_cache
    else 
      @searchResults = {
        "error" => "Your Session is Exprired. Please search again."
      }
    end
  end

  private
  def get_session_name
    session[:session_name] = DateTime.now.to_s
  end

  def save_search_cache
    Rails.cache.write("#{session[:session_name]}searchResults", instance_variable_get("@searchResults"), expires_in: 10.minutes)
  end

  def get_search_cache
    instance_variable_set("@searchResults", Rails.cache.read("#{session[:session_name]}searchResults"))
  end

end
