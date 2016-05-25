# We add this monkey patch to ensure the
# overviews are destroyed when the exhibit is
require File.expand_path('../../app/models/spotlight/exhibit', Spotlight::Engine.called_from)
module Spotlight
  class Exhibit
    has_many :exhibit_overviews, dependent: :destroy

    def patched?
      true
    end
  end
end
