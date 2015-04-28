require 'test_helper'
class RepositoryIntegrationTest < Minitest::Test

  def teardown
    SbbHexagonal::RepositoryManager.repositories.clear
    SbbHexagonal::RepositoryManager.configuration = nil
  end

  context 'consumer specified repository' do
    should 'return registered repository' do
      SbbHexagonal::RepositoryManager.register(:inventories, InventoriesRepository)
      controller = MockProductsController.new
      repo = controller.repo
      assert_equal InventoriesRepository, repo
    end

    should 'create repository when one is not registered' do
      assert_nil SbbHexagonal::RepositoryManager.for(:inventories)
      controller = MockProductsController.new
      repo = controller.repo
      assert_equal InventoriesRepository, repo
    end

    should 'throw NameError when repository is neither registered nor creatable' do
      controller = MockProduct.new
      controller.class.register_repository(:i_do_not_exist)
      assert_raises(NameError) { controller.repo }
      # need to tidy up
      controller.class.instance_variable_set(:@repository_name, controller.class.derived_name)
    end
  end

  context 'derived repository name' do
    should 'return registered repository' do
      SbbHexagonal::RepositoryManager.register(:mock_products, MockProductsRepository)
      controller = MockProduct.new
      repo = controller.repo
      assert_equal MockProductsRepository, repo
    end

    should 'create repository when one is not registered' do
      assert_nil SbbHexagonal::RepositoryManager.for(:mock_products)
      controller = MockProduct.new
      repo = controller.repo
      assert_equal MockProductsRepository, repo
    end

    should 'throw NameError when repository is neither registered nor creatable' do
      controller = MockInventory.new
      assert_raises(NameError) { controller.repo }
    end
  end

  def create_repository_modules
    sbb = Module.new
    Object.const_set 'Sbb', sbb
    sbb_support = Module.new
    Sbb.const_set('Support', sbb_support)
  end

  context 'derived name with customized repository naming' do
    should 'return registered repository' do
      create_repository_modules
      Sbb::Support::ProductsStore = Class.new {}
      SbbHexagonal::RepositoryManager.register(:mock_products, Sbb::Support::ProductsStore)
      controller = MockProduct.new
      repo = controller.repo
      assert_equal Sbb::Support::ProductsStore, repo
    end

    should 'create repository when one is not registered' do
      create_repository_modules
      Sbb::Support::MockProductsStore = Class.new {}
      module_config = OpenStruct.new(module_prefix: 'Sbb::Support', name_suffix: 'Store')
      SbbHexagonal::RepositoryManager.configuration = module_config
      assert_nil SbbHexagonal::RepositoryManager.for(:mock_products)
      controller = MockProduct.new
      repo = controller.repo
      assert_equal Sbb::Support::MockProductsStore, repo
    end

    should 'throw NameError when repository is neither registered nor creatable' do
      create_repository_modules
      module_config = OpenStruct.new(module_prefix: 'Sbb::Support', name_suffix: 'Store')
      SbbHexagonal::RepositoryManager.configuration = module_config
      assert_nil SbbHexagonal::RepositoryManager.for(:mock_products)
      controller = MockProduct.new
      assert_raises(NameError) { controller.repo }
    end
  end
end
