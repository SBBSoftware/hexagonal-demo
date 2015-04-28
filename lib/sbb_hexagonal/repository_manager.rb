module SbbHexagonal
  class RepositoryManager

    @configuration = nil
    class << self
      attr_accessor :configuration
    end

    def self.register(key, repository)
      repositories[key.to_sym] = repository
    end

    def self.repositories
      @repositories ||= {}
    end

    def self.for(repository_key)
      repositories[repository_key]
    end

    # will attempt to create a repository from a derived class
    def self.create(key)
      return register(key, Kernel.const_get(key_to_class_name(key))) unless repositories.key?(key)
      fail NameError, 'Key already exists'
    end

    # derive class name from repository key
    def self.key_to_class_name(key)
      "#{module_prefix}#{key.to_s.classify.pluralize}#{name_suffix}"
    end

    def self.name_suffix
      return 'Repository' unless configuration
      configuration.name_suffix ||= 'Repository'
    end

    def self.module_prefix
      return nil unless configuration
      configuration.module_prefix ? "#{configuration.module_prefix}::" : nil
    end

  end
end
