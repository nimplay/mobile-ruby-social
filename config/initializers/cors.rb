Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://10.0.2.2:3000', 'http://localhost:3000' 
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end
