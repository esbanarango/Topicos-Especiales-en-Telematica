class IntegradorController < ApplicationController

  # GET /webdSearch
  def WebDSearch
  	@search = {}
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def search
    responseFinal = webService(params[:q])

  	respond_to do |format|  
        format.js  
    end  
  end

  # GET /webdSearch.json
  def WSS_DSearch
  	respond_to do |format|
      format.json { render json: webService(params[:q]) }
    end
  end

  private

  def webService(query)
    @workers = getWorkers

    workerNumber = rand(0...@workers.size)
    #@response = @workers[workerNumber]

    initServer(@workers[workerNumber])

    data = { "query"=> query }

    @response = getData("/WSS_Search",data,true)

    @response["answers"].each do |ans|
      ans["url"] = @workers[workerNumber]+ans["url"]
    end    
    @responseFinal = {}
    @responseFinal[:request] = {question: query, answers: @response["answers"]}

  end
  


end
