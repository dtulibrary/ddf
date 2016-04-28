# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


# Monkey patch Blacklight to enable OR logic with facets
# Inspired by https://github.com/WGBH/AAPB2/blob/master/config/environment.rb
# See also https://groups.google.com/forum/#!topic/blacklight-development/ucEylXEgbNM
# This will need to be updated with upgrade to Blacklight 5.11
module Blacklight
  module RequestBuilders

    ##
    # Convert a facet/value pair into a solr fq parameter
    def facet_value_to_fq_string(facet_field, value)
      facet_config = blacklight_config.facet_fields[facet_field]

      local_params = []
      local_params << "tag=#{facet_config.tag}" if facet_config and facet_config.tag

      prefix = ""
      prefix = "{!#{local_params.join(" ")}}" unless local_params.empty?
      case
        when (facet_config and facet_config.query)
          facet_config.query[value][:fq]
        when (facet_config and facet_config.date)
          # in solr 3.2+, this could be replaced by a !term query
          "#{prefix}#{facet_field}:#{RSolr.escape(value)}"
        when (value.is_a?(DateTime) or value.is_a?(Date) or value.is_a?(Time))
          "#{prefix}#{facet_field}:#{RSolr.escape(value.to_time.utc.strftime("%Y-%m-%dT%H:%M:%SZ"))}"
        when (value.is_a?(TrueClass) or value.is_a?(FalseClass) or value == 'true' or value == 'false'),
             (value.is_a?(Integer) or (value.to_i.to_s == value if value.respond_to? :to_i)),
             (value.is_a?(Float) or (value.to_f.to_s == value if value.respond_to? :to_f))
          "#{prefix}#{facet_field}:#{RSolr.escape(value.to_s)}"
        when value.is_a?(Range)
          "#{prefix}#{facet_field}:[#{value.first} TO #{value.last}]"
        when value.include?(' OR ')
          "#{facet_field}:(#{value})"
          # this was how AAPB2 did it in their monkey patch
          # prefix + value.split(' OR ').map { |single| "#{facet_field}:\"#{single}\"" }.join(' ')
        else
          "{!raw f=#{facet_field}#{(" " + local_params.join(" ")) unless local_params.empty?}}#{value}"
      end
    end
  end
end
