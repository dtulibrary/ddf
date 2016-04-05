class ExhibitOverview < ActiveRecord::Base
  belongs_to :exhibit, class: Spotlight::Exhibit
end
