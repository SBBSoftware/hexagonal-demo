class MockProductsController < ActionController::Base
  include SbbHexagonal::RepositoryAdapter

  register_repository :inventories
end
