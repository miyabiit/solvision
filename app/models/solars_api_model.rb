class SolarsAPIModel
  include ActiveAttr::Model

  thread_mattr_accessor :_connection
  class_attribute :_resource_path

  class << self
    def find(id)
      setup_connection
      res = _connection.get(_resource_path + '/' + id)
      raise ActiveRecord::RecordNotFound unless res
      new(JSON.parse(res.body))
    end

    def where(params)
      setup_connection
      res = _connection.get(_resource_path, params)
      raise ActiveRecord::RecordNotFound unless res.present?
      JSON.parse(res.body).map { |attrs| new(attrs) }
    end

    def all
      where({})
    end

    def setup_connection
      self._connection ||= Faraday.new(url: ENV['SOLARS_API_PATH'])
    end

    def resource_path(path)
      self._resource_path = path
    end
  end
end
