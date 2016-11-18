class AnalyzeController < ApplicationController

  def results
    @lsi_result = params[:lsi_result]
    @bayes_result = params[:bayes_result]
  end

  def code

    code = analyze_params[:code]
    lsi_result = Trainer.instance.classify_lsi code
    bayes_result = Trainer.instance.classify code
    redirect_to results_path(lsi_result: lsi_result, bayes_result: bayes_result)
  end


  def analyze_params
    params.permit(:code)
  end

end
