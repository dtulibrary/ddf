module Spotlight
  class Exhibit < ActiveRecord::Base
    include Spotlight::ExhibitBehavior
    def solr_data
      {}
    end
  end
end
