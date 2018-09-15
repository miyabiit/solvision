class ShabotAPIModel
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
      res = _connection.get do |req|
        req.url _resource_path
        req.headers['Authorization'] = "Token #{ENV['SHABOT_API_AUTH_KEY']}"
        req.params = params
      end
      raise ActiveRecord::RecordNotFound unless res.present?
      JSON.parse(res.body).map { |attrs| new(attrs) }
    end

    def all
      where({})
    end

    def setup_connection
      self._connection ||= Faraday.new(url: ENV['SHABOT_API_PATH'], headers: {'Authorization' => "Token #{ENV['SHABOT_API_AUTH_KEY']}"}, ssl: { verify: false })
    end

    def resource_path(path)
      self._resource_path = path
    end
  end
end
