class Site

  class InvalidState < Exception; end
  include Mongoid::Document
  field :url

  def url=(new_url)
    if !self.instance_variable_defined?(:@new_record) and persisted?
      raise InvalidState
    end
  end
end

