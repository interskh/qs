class FoursquareController < ApplicationController
  
  before_filter :require_user
  
  def index
    # list all the examples
#    redirect_to :action => :checkins
    
  end
  
  def user
  end
  
  def checkins
    if params[:all]
      checkins = current_user.all_checkins
      @all = true
      @current_year = false
    elsif params[:current_year]
      checkins = []
      offset = 0
      parts = current_user.checkins(:limit => 250, :offset => offset)
      current_year = parts.first.created_at.to_date.year
      while parts.last.created_at.to_date.year == current_year do
        checkins += parts
        offset += 250
        parts = current_user.checkins(:limit => 250, :offset => offset)
      end
      parts.each do |c|
        if c.created_at.to_date.year == current_year
          checkins.append c
        end
      end
      @current_year = true
      @all = false
    else
      checkins = current_user.some_checkins 250
      @current_year = false
      @all = false
    end

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
    all_category_data = Hash.new(0)

    week_columns = Array.new
    data_by_week = Hash.new(0)
    category_data_by_week = Hash.new{|v,k| v[k] = Hash.new(0)}
    last_time = checkins.first.created_at + 7*24*60*60
    time = checkins.last.created_at
    while (time <=> last_time) == -1 do
      date = time.to_date
      week = Date.commercial(date.year, date.cweek).to_time.to_i*1000
      week_columns << week
      time += 7*24*60*60
    end
    week_columns.each do |column|
      data_by_week[column] = 0
      categories.each do |c|
        category_data_by_week[c['name']][column] = 0
      end
      category_data_by_week['Unknown'][column] = 0
    end

    month_columns = Array.new
    data_by_month = Hash.new(0)
    category_data_by_month = Hash.new{|v,k| v[k] = Hash.new(0)}
    last_date = (checkins.first.created_at).to_date
    date = checkins.last.created_at.to_date
    while date < last_date do
      month = date.at_beginning_of_month.to_time.to_i*1000
      month_columns << month
      date = date.next_month
    end
    month_columns.each do |column|
      data_by_month[column] = 0
      categories.each do |c|
        category_data_by_month[c['name']][column] = 0
      end
      category_data_by_month['Unknown'][column] = 0
    end

    venues = {}
    checkins.each do |c|
      unless c.venue.nil?
        if venues.has_key?(c.venue.id)
          venues[c.venue.id].append(c.venue)
        else
          venues[c.venue.id] = [c.venue]
        end
      end

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
      all_category_data[category] += 1

      date = c.created_at.to_date
      week = Date.commercial(date.year, date.cweek).to_time.to_i*1000
      if week_columns.include?(week)
        data_by_week[week] += 1
        category_data_by_week[top][week] += 1
      else
        Rails.logger.info(c.inspect)
      end

      month = date.at_beginning_of_month.to_time.to_i*1000
      if month_columns.include?(month)
        data_by_month[month] += 1
        category_data_by_month[top][month] += 1
      else
        Rails.logger.info(c.inspect)
      end
    end

    # to get top venues
    sorted_venues = venues.sort_by {|k,v| v.size}
    sorted_venues.last(10).each do |v|
      Rails.logger.info(v[1].size)
      Rails.logger.info(v[1][0].name)
    end

    category_data = category_data.sort_by {|k,v| -v}
    all_category_data = all_category_data.sort_by {|k,v| -v}
    detailed_category_data.each do |c, cc|
      detailed_category_data[c] = cc.sort_by {|k,v| -v}
    end

    @data = Hash.new
    @data['category_all'] = category_data.to_a
    @data['category_all_detailed'] = all_category_data.to_a
    @data['category_detailed'] = Hash.new
    detailed_category_data.each do |x,y|
      @data['category_detailed'][x] = y.to_a
    end

    @data['week'] = week_columns.to_a
    @data['all_by_week'] = data_by_week.to_a
    @data['category_by_week'] = Hash.new
    category_data_by_week.each do |x,y|
      @data['category_by_week'][x] = y.to_a
    end

    @data['month'] = month_columns.to_a
    @data['all_by_month'] = data_by_month.to_a
    @data['category_by_month'] = Hash.new
    category_data_by_month.each do |x,y|
      @data['category_by_month'][x] = y.to_a
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
