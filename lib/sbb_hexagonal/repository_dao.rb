module SbbHexagonal
  module RepositoryDAO

    def my_dao_is(dao_class)
      @dao = dao_class
    end

    def dao
      @dao
    end

    def new(params = {})
      @dao.new(params)
    end

    def create(params = {})
      @dao.create(params)
    end

    def create_with(params = {}, &block)
      @dao.create_with(params, &block)
    end

    # activerecord style all
    def all
      @dao.all
    end

    # active record style find
    def find(id)
      find_by_id(id)
    end

    def find_by_id(id)
      @dao.find(id)
    end

    def delete_all
      @dao.delete_all
    end
  end
end
