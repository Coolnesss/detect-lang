require 'classifier-reborn'
require 'singleton'

class Trainer
  include Singleton

  def initialize
    @bayes = ClassifierReborn::Bayes.new *categories
    @lsi = ClassifierReborn::LSI.new
    train
    train_lsi
  end

  def bayes
    @bayes
  end

  def observations
    Observation.all.reject{|x| not x.lang or x.lang.empty?}
  end

  def categories
    Observation.all.pluck(:lang).reject{|x| not x or x.empty?}.uniq
  end

  def train
    observations.each do |obs|
      @bayes.send "train_#{obs.lang}", obs.code
    end
  end

  def train_lsi
    observations.each do |obs|
      @lsi.add_item obs.code, obs.lang
    end
  end

  def classify(obj)
    @bayes.classify obj
  end

  def classify_lsi(obj)
    @lsi.classify obj
  end

  def find_related(obj)
    @lsi.find_related obj
  end

  #def find_related(code, amount = 1)
  #  @.find_related code, amount
  #end

  def training_data(per_page=30)
    gists = JSON.parse(RestClient.get("https://api.github.com/gists/public?per_page=#{per_page}"))
    github = Github.new oauth_token: ENV["GITHUB_TOKEN"]

    gists.each do |gist|
      id = gist["id"]
      files = github.gists.find(id).body.files
      files.each do |file|
        content = file[1].content
        lang = file[1].language
        puts lang
        Observation.create code: content, lang: lang
      end
    end
    true
  end

  def fetch_data(iterations=10, per_page=30)
    iterations.times do
      training_data(per_page)
    end
  end
end
