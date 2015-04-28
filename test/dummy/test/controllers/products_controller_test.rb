require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    # create some records
    SbbHexagonal::RepositoryManager.register(:products, Sbb::Repository::Memory::ProductsRepository)
    repo = SbbHexagonal::RepositoryManager.for(:products)
    product = repo.new(name: 'test 1', sku: 'sku1')
    product.save
    @product_id = product.id
    product = repo.new(name: 'test 2', sku: 'sku2')
    product.save
  end

  teardown do
    repo = SbbHexagonal::RepositoryManager.for(:products)
    repo.empty
  end

  should 'get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    assert_equal 2, assigns(:products).length
  end

  should 'get new' do
    get :new
    assert_response :success
  end

  should 'create product' do
    repo = SbbHexagonal::RepositoryManager.for(:products)
    start_count = repo.all.count
    post :create, product: { name: 'test 3', sku: 'sku3' }
    assert_redirected_to product_path(assigns(:product))
    end_count = repo.all.count
    assert_equal 1, end_count - start_count
  end

  should 'show product' do
    get :show, id: @product_id
    assert_response :success
  end

  should 'get edit' do
    get :edit, id: @product_id
    assert_response :success
  end

  should 'update product' do
    patch :update, id: @product_id, product: { name: 'i have been changed' }
    assert_redirected_to product_path(assigns(:product))
  end

  should 'destroy product' do
    repo = SbbHexagonal::RepositoryManager.for(:products)
    start_count = repo.all.count
    delete :destroy, id: @product_id
    end_count = repo.all.count
    assert_equal 1, start_count - end_count
    assert_redirected_to products_path
  end
end
