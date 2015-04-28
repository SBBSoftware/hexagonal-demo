module Sbb
  module Repository
    module Memory
      class ProductsRepository
        include ActiveModel::Naming, ActiveModel::Model
        # in memory table class variable
        @data = {}
        # in memory id counter class variable
        @counter = 0

        # model instance attributes
        attr_accessor :id, :sku, :name, :blurb

        # mimic product for naming and actionpack
        def self.model_name
          ActiveModel::Name.new(ProductsRepository, nil, 'Product')
        end

        # set up class variable access accessors
        class << self
          attr_accessor :data, :counter
        end

        # activerecord style all
        def self.all
          @data.values
        end

        # active record style find
        def self.find(id)
          find_by_id(id)
        end

        def self.find_by_id(id)
          @data[id.to_i]
        end

        def self.empty
          @data = {}
        end

        # initializer with optional params
        def initialize(params = {})
          self.attributes = params
        end

        # for views to switch between patch and post for form partials
        def persisted?
          id && id > 0 ? true : false
        end

        # persist to memory
        def save
          @id = self.class.counter += 1
          update
        end

        # update memory
        def update(params = {})
          self.attributes = params
          self.class.data[id.to_i] = self
        end

        # destroy record
        def destroy
          self.class.data.delete(id.to_i)
        end

        private

        # attribute setter by param
        def attributes=(params)
          params.each_pair do |k, v|
            setter = "#{k}=".to_sym
            public_send(setter, v)
          end
        end
      end
    end
  end
end
