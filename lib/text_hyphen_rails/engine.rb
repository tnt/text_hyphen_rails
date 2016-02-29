module TextHyphenRails
  class Engine < ::Rails::Engine
    isolate_namespace TextHyphenRails

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer :append_migrations do |app|
      if root != app.root
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end
  end
end
