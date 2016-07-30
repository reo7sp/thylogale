class PageSearchController < ApplicationController
  def index
  end

  def show
    @query = params[:id]
    @search_results = Page.search_by_title(@query) + PageFolder.search_by_title(@query)
  end
end
