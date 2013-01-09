class ExamplesController < ApplicationController
  
  before_filter :require_user
  
  def index
    # list all the examples
    
  end
  
  def user
  end
  
  def checkins
    checkins = current_user.all_checkins

    categories = foursquare.venues.categories
    category_parents = Hash.new
    category_tops = Hash.new
    categories.each do |c|
      category_tops[c['name']] = c['name']
      c['categories'].each do |cc|
        category_parents[cc['name']] = c['name']
        _category_parent_n_top(category_parents, category_tops, c['name'], cc)
      end
    end

    category_data = Hash.new
    detailed_category_data = Hash.new
    checkins.each do |c|
      if c.venue.nil? || c.venue.primary_category.nil?
        top = category = "Unknown"
      elsif category_tops[c.venue.primary_category.name].nil?
        top = category = c.venue.primary_category.name
      else
        category = c.venue.primary_category.name
        top = category_tops[category]
      end
      if category_data[top].nil?
        category_data[top] = 1
        detailed_category_data[top] = Hash.new
      else
        category_data[top] += 1
        if detailed_category_data[top][category].nil?
          detailed_category_data[top][category] = 1
        else
          detailed_category_data[top][category] += 1
        end
      end
    end

    @pie_data = Hash.new
    @pie_data['all'] = category_data.to_a
    @pie_data['detailed'] = Hash.new
    detailed_category_data.each do |x,y|
      @pie_data['detailed'][x] = y.to_a
    end
  end
  
  def friends
  end
  
  def venues_search
    if params[:name]
      # venues is a hash, with keys that represents different type of results
      # see "Response Fields" in this page: https://developer.foursquare.com/docs/venues/search.html
      # for more details
      @venues = foursquare.venues.search(:query => params[:name], :ll => "48.857,2.349")
    end
  end
  
  def venue_details
    # default venue is the "Tour Eiffel"
    @venue_id = params[:venue_id] || "185194"
    @venue = foursquare.venues.find(@venue_id)
  end
  
  private
  def _category_parent_n_top(parents, tops, top_c, c) 
    tops[c['name']] = top_c
    if c['categories'].present?
      c['categories'].each do |child|
          parents[child['name']] = c['name']
          _category_parent_n_top(parents, tops, top_c, child)
      end
    end
  end
end
