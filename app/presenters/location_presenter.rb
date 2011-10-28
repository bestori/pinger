class LocationPresenter < BasePresenter

  presents :location

  delegate :id, :title, :url, :seconds, :to => :location

  def next_ping
    now = Time.now
    if location.next_ping_date && location.next_ping_date > now
      distance_of_time_in_words now, location.next_ping_date
    else
      'just a moment'
    end
  end

  def http_method
    location.http_method.upcase
  end

  def pings
    @ping ||= location.pings.performed.order { performed_at.desc }
  end

  def paginated_pings
    @paginated_pings ||= pings.paginate params[:page], CONFIG[:app][:pings_per_page]
  end

  def render_pings
    if paginated_pings.present?
      render 'pings/table', :pings => paginated_pings
    else
      content_tag :p, 'No pings yet.', :class => 'empty'
    end
  end

  [nil, :edit, :delete].each do |name|
    define_method (name ? "#{name}_path" : 'path') do
      send (name ? "#{name}_location_path" : 'location_path'), location
    end
  end

  def form(&block)
    form_for location do |form_builder|
      form_presenter = Form.new self, form_builder
      if block.arity > 0
        yield form_presenter
      else
        form_presenter.instance_eval &block
      end
    end
  end

end