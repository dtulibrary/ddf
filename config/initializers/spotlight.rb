# See available config options here:
# https://github.com/sul-dlss/spotlight/blob/master/lib/spotlight/engine.rb

Spotlight::Engine.config.solr_fields.boolean_suffix = '_ss'.freeze
Spotlight::Engine.config.writable_index = false
Spotlight::Engine.config.full_image_field = nil
Spotlight::Engine.config.exhibit_filter = lambda do |exhibit|
  { }
end
Spotlight::Engine.config.filter_resources_by_exhibit = false
Spotlight::Engine.config.solr_fields.boolean_suffix = '_b'.freeze
Spotlight::Engine.config.show_search_sidebar = false
