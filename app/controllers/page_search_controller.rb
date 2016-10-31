class PageSearchController < ApplicationController
  def index
  end

  def show
    @query          = params[:id]
    found_folders   = PageFolder.search(name_or_title_cont: @query, id_not_eq: 1).result
    found_pages     = Page.search(name_or_title_cont: @query).result
    @search_results = found_folders + found_pages
  end
end
