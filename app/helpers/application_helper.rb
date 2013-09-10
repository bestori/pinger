module ApplicationHelper
  # TODO: test
  def present(object, klass = nil, &block)
    presenter = if !klass && object.respond_to?(:to_presenter)
      object.to_presenter(self)
    else
      "#{object.class}Presenter".constantize.new object, self
    end
    if block_given?
      block.arity > 0 ? yield(presenter) : presenter.instance_eval(&block)
    end
    presenter
  end

  def locations
    @locations ||= Location.order { title.asc }
  end

  def paginated_locations
    @paginated_locations ||= locations.paginate params[:page], CONFIG[:app][:locations_per_page]
  end

  def alerts
    @alerts ||= Alert.joins { location }.order { locations.title.asc }
  end

  def email_callbacks
    @email_callbacks ||= EmailCallback.order { label.asc }
  end
end
