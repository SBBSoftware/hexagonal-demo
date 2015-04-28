# simplest repository class is an ActiveRecord
class ProductsRepository < ActiveRecord::Base

  self.table_name = 'products'
  # override model_name to make the object respond as though
  # it is a product for Naming and ActionPack
  def self.model_name
    ActiveModel::Name.new(ProductsRepository, nil, 'Product')
  end

end
