# We add this monkey patch to ensure the
# overviews are destroyed when the exhibit is
require File.expand_path('../../app/models/spotlight/exhibit', Spotlight::Engine.called_from)
module Spotlight
  class Exhibit
    has_many :exhibit_overviews, dependent: :destroy

    # Convenience method so view doesn't have to
    # reach deep into the guts of Spotlight
    # to get its nav elements
    def nav_pages
      feature_pages.published.at_top_level.order(:weight)
    end
    def patched?
      true
    end
  end
end
