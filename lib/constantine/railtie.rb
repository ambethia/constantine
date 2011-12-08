module Constantine
  class Railtie < Rails::Railtie

    config.after_initialize do
      ActiveSupport::Inflector.send :extend, Constantine::Support
    end
  end
end
