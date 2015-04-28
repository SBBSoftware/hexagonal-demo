require 'test_helper'

class RepositoryAdapterTest < Minitest::Test

  context 'derived name' do
    should 'return controller name when object responds to controller name' do
      name = MockProductsController.derived_name
      assert_equal 'mock_products', name
    end

    should 'return model name when object responds to model name' do
      name = MockInventory.derived_name
      assert_equal 'mock_inventories', name
    end

    should 'return object name for objects not responding to controller name or model name' do
      name = MockProduct.derived_name
      assert_equal 'mock_products', name
    end
  end

  context 'repository key' do
    should 'always be a symbol' do
      controller = MockProductsController.new
      repo_name = 'frying_pan'
      controller.singleton_class.register_repository(repo_name)
      key = controller.singleton_class.repository_key
      assert key.is_a?(Symbol)
      assert_equal repo_name.to_sym, key
    end

    should 'return specified name when it is supplied by the class' do
      repository_name = :large_hardron_colliders
      specific_registration = Class.new do
        include SbbHexagonal::RepositoryAdapter
        register_repository repository_name
      end
      Object.const_set 'SpecificRepositoryClass', specific_registration
      key = SpecificRepositoryClass.repository_key
      assert_equal repository_name, key
    end
  end
end
