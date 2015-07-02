class MockStock
  include ActiveModel::Model,
          SbbHexagonal::RepositoryAdapter
  register_repository :warehouse_stocks
end
