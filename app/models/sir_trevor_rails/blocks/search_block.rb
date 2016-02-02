module SirTrevorRails
  module Blocks
    ##
    # Search summary block
    class SearchBlock < SirTrevorRails::Block
      attr_reader :solr_helper

      def with_solr_helper(solr_helper)
        @solr_helper = solr_helper
      end

      def exhibit
        parent.exhibit
      end

      # Note that this method presumes there is only one applicable search
      # It may need to be refactored if we decide to connect multiple searches
      # to an author exhibit
      def search
        @search ||= exhibit.searches.first
        # @searches ||= exhibit.searches.published.where(slug: item_ids).sort do |a, b|
        #   order.index(a.slug) <=> order.index(b.slug)
        # end
      end

      # def item_ids
      #   items.map { |v| v[:id] }
      # end
      #
      # def items
      #   item.values.select { |x| x[:display] == 'true' }
      # end
      # return top documents
      def documents
        date_sort = solr_helper.blacklight_config.sort_fields.find {|k,v| v.label == 'year' }.first
        search_params = search.query_params.merge(sort: date_sort)
        solr_helper.search_results(search_params, solr_helper.search_params_logic).last
      end

      def item_count
        solr_helper.search_results(search.query_params, solr_helper.search_params_logic).first['response']['numFound']
      end
    end
  end
end
