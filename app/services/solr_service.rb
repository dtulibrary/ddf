class SolrService
  include ::Blacklight::Configurable
  include ::Blacklight::SolrHelper
  include ::Blacklight::RequestBuilders

  def self.author_docs(cris_ids)
    return response_hash(0) if cris_ids.empty?
    result = Blacklight.solr.get('ddf_publ', params: {
      q: "cris_id_ss:#{self.cris_search(cris_ids)}",
      fq: 'access_ss:ddf_publ AND NOT format:person',
      sort: 'pub_date_tsort desc',
      wt: 'json',
      fl: '*',
      rows: 10
      }
    )
    response_hash(result['response']['numFound'], result['response']['docs'])
  end

  def self.cris_search(ids)
    ids.size == 1 ? ids.first : "(#{ids.join(' OR ')})"
  end

  def self.response_hash(count, docs = [])
    { size: count, docs: docs }
  end
end
