class AnalyzeController < ApplicationController

  def results
    @lsi_result = params[:lsi_result]
    @bayes_result = params[:bayes_result]
    @related = params[:related]
  end

  def code

    code = analyze_params[:code]
    lsi_result = Trainer.instance.classify_lsi code
    bayes_result = Trainer.instance.classify code
    related = Trainer.instance.find_related(code).first[1..200]
    redirect_to results_path(lsi_result: lsi_result, bayes_result: bayes_result, related: related)
  end


  def analyze_params
    params.permit(:code)
  end

end
