class SolrService
  include ::Blacklight::Configurable
  include ::Blacklight::SolrHelper
  include ::Blacklight::RequestBuilders

  def author_docs(cris_id)
    return { size: 0, docs: [] } unless cris_id.present?
    result = Blacklight.solr.get('ddf_publ', params: {
      q: "cris_id_ss:#{cris_id}",
      fq: 'access_ss:ddf_publ AND NOT format:person',
      sort: 'pub_date_tsort desc',
      wt: 'json',
      fl: '*',
      rows: 10
      }
    )
    { size: result['response']['numFound'], docs: result['response']['docs'] }
  end
end
