require "#{Rails.root}/app/lib/article.rb"

CONTENTS_DIR = 'contents'

class ArticlesController < ApplicationController
  def initialize
    @articles = Array.new

    articles_pattern =
        "#{Rails.root}/app/views/articles/#{CONTENTS_DIR}/_*#{ARTICLE_FORMAT}"
    Dir.glob(articles_pattern).each do |file|
      name = File.basename(file, ARTICLE_FORMAT)
      SYMBOLS.each { |key, symbol| name.sub!(key, "_#{symbol}_") }
      title = name.titleize
      time = File.birthtime(file)
      path = "articles/#{CONTENTS_DIR}/#{File.basename(file)[1..-1]}"
      @articles << Article.new(title, time, path)
    end

    @articles.sort_by! { |article| article.time }.reverse!

    super
  end

  def index
  end

  def show
    @article = @articles.find do |a|
      File.basename(a.path, ARTICLE_FORMAT).eql? File.basename(request.path)
    end
    raise ActionController::RoutingError.new('Not Found') unless @article
  end
end
