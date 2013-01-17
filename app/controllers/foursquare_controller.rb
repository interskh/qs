class FoursquareController < ApplicationController
  
  before_filter :require_user
  
  def index
    # list all the examples
#    redirect_to :action => :checkins
    
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

    category_data = Hash.new(0)
    detailed_category_data = Hash.new{|v,k| v[k] = Hash.new(0)}
    data_by_week = Hash.new(0)
    category_data_by_week = Hash.new{|v,k| v[k] = Hash.new(0)}
    checkins.each do |c|
      if c.venue.nil? || c.venue.primary_category.nil?
        top = category = "Unknown"
      elsif category_tops[c.venue.primary_category.name].nil?
        top = category = c.venue.primary_category.name
      else
        category = c.venue.primary_category.name
        top = category_tops[category]
      end
      category_data[top] += 1
      detailed_category_data[top][category] += 1

      week = c.created_at.strftime("%Y-%W")
      data_by_week[week] += 1
      category_data_by_week[top][week] += 1
    end

    category_data = category_data.sort_by {|k,v| -v}
    detailed_category_data.each do |c, cc|
      detailed_category_data[c] = cc.sort_by {|k,v| -v}
    end

    @data = Hash.new
    @data['category_all'] = category_data.to_a
    @data['category_detailed'] = Hash.new
    detailed_category_data.each do |x,y|
      @data['category_detailed'][x] = y.to_a
    end

    @data['all_by_week'] = data_by_week.to_a
    @data['category_by_week'] = Hash.new
    category_data_by_week.each do |x,y|
      @data['category_by_week'][x] = y.to_a
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
