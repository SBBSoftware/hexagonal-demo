require 'test_helper'

class MockInventory
  include ActiveModel::Model,
          SbbHexagonal::RepositoryAdapter

end
