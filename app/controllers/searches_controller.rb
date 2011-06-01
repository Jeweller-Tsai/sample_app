class SearchesController < ApplicationController
  before_filter :authenticate
  def index
    redirect_to(root_path) and return if params[:q].nil?

    query = params[:q].strip.inspect
    model = params[:model]
    page  = params[:page] || 1

    unless %(User Page).include?(model)
      flash[:error]="Invalid search!"
      redirect_to(root_path) and return
    end

    if query.blank?
      @results = []
    else
      if model == "User"
        #@results = User.search(query).paginate(:page => page)
        @results = User.search query, :page => page
      else
        @results = Micropost.search query, :page => page,
                                           :conditions => {:created_at => 1.month.ago.to_i..Time.now.to_i}
        #@results = Micropost.search(query, :conditions => {:created_at => 1.month.ago.to_i..Time.now.to_i}).paginate(:page => page)
      end
    end
  end

end

