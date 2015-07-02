require 'test_helper'

class RepositoryManagerTest < Minitest::Test

  # repository_stub = nil
  # setup do
  #   repository_stub = 'i am a stub'
  # end

  def teardown
    SbbHexagonal::RepositoryManager.repositories.clear
    SbbHexagonal::RepositoryManager.configuration = nil
  end

  should 'return nil when repository does not exist' do
    repo = SbbHexagonal::RepositoryManager.for(:product)
    assert_nil repo
  end

  should 'return repository for when key is registered' do
    repository_stub = 'i am a stub'
    SbbHexagonal::RepositoryManager.register(:product, repository_stub)
    repo = SbbHexagonal::RepositoryManager.for(:product)
    assert_equal repository_stub, repo
  end

  should 'return repository during registration' do
    repository_stub = 'i am a stub'
    repo = SbbHexagonal::RepositoryManager.register(:product, repository_stub)
    assert_equal repository_stub, repo
  end

  should 'overwrite repository during registration' do
    repository_stub = 'i am a stub'
    SbbHexagonal::RepositoryManager.register(:product, repository_stub)
    duplicate_repo = SbbHexagonal::RepositoryManager.register(:product, 'hello repository')
    product_repo = SbbHexagonal::RepositoryManager.for(:product)
    assert_equal product_repo, duplicate_repo
  end

  should 'create classname from key' do
    assert_equal 'MockProductsRepository', SbbHexagonal::RepositoryManager.key_to_class_name(:mock_products)
    assert_equal 'ProductsRepository', SbbHexagonal::RepositoryManager.key_to_class_name(:products)
    assert_equal 'InventoriesRepository', SbbHexagonal::RepositoryManager.key_to_class_name(:inventories)
    assert_equal 'TwoBigWheelsRepository', SbbHexagonal::RepositoryManager.key_to_class_name(:two_big_wheels)
  end

  should 'use custom configured repository suffix in derived class name' do
    SbbHexagonal::RepositoryManager.configuration = OpenStruct.new(name_suffix: 'Storage')
    assert_equal 'MockProductsStorage', SbbHexagonal::RepositoryManager.key_to_class_name(:mock_products)
    assert_equal 'ProductsStorage', SbbHexagonal::RepositoryManager.key_to_class_name(:products)
    assert_equal 'InventoriesStorage', SbbHexagonal::RepositoryManager.key_to_class_name(:inventories)
    assert_equal 'TwoBigWheelsStorage', SbbHexagonal::RepositoryManager.key_to_class_name(:two_big_wheels)
    SbbHexagonal::RepositoryManager.configuration = OpenStruct.new(name_suffix: 'LargeHadronCollider')
    assert_equal 'MockProductsLargeHadronCollider', SbbHexagonal::RepositoryManager.key_to_class_name(:mock_products)
    assert_equal 'ProductsLargeHadronCollider', SbbHexagonal::RepositoryManager.key_to_class_name(:products)
    assert_equal 'InventoriesLargeHadronCollider', SbbHexagonal::RepositoryManager.key_to_class_name(:inventories)
    assert_equal 'TwoBigWheelsLargeHadronCollider', SbbHexagonal::RepositoryManager.key_to_class_name(:two_big_wheels)
  end

  context 'creating repository' do
    should 'find valid class from key' do
      ::UsersRepository = Class.new {}
      repo = SbbHexagonal::RepositoryManager.create(:users)
      refute_nil repo
      assert_equal UsersRepository, repo
    end

    should 'create valid class with module prefix' do
      module_config = OpenStruct.new(module_prefix: 'Sbb::Support')
      SbbHexagonal::RepositoryManager.configuration = module_config
      sbb = Module.new
      Object.const_set 'Sbb', sbb
      sbb_support = Module.new
      Sbb.const_set('Support', sbb_support)
      Sbb::Support::UsersRepository = Class.new {}
      repo = SbbHexagonal::RepositoryManager.create(:users)
      assert_equal Sbb::Support::UsersRepository, repo
    end

    should 'raise exception when trying to create existing key' do
      ::InventoriesRepository = Class.new {}
      SbbHexagonal::RepositoryManager.register(:mock_products, InventoriesRepository)
      assert_raises(NameError) { SbbHexagonal::RepositoryManager.create(:mock_products) }
      repo = SbbHexagonal::RepositoryManager.for(:mock_products)
      assert_equal InventoriesRepository, repo
    end

    should 'raise exception when repository not found' do
      assert_raises(NameError) { SbbHexagonal::RepositoryManager.create(:i_dont_exist) }
    end

    should 'ensure i am not an idiot' do
      products_controller = MockProductsController.new
      stocks_controller = MockStocksController.new
      inventory_object = MockInventory.new
      stock_object = MockStock.new
      products_controller_name = products_controller.class.repository_key
      stocks_controller_name = stocks_controller.class.repository_key
      inventory_name = inventory_object.class.repository_key
      stock_name = stock_object.class.repository_key
      refute [products_controller_name, stocks_controller_name, inventory_name].include?(stock_name)
      refute [stock_name, stocks_controller_name, inventory_name].include?(products_controller_name)
      refute [stock_name, products_controller_name, inventory_name].include?(stocks_controller_name)
      refute [stock_name, products_controller_name, stocks_controller_name ].include?(inventory_name)
    end
  end

end
