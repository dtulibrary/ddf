class SolrService
  include ::Blacklight::Configurable
  include ::Blacklight::SolrHelper
  include ::Blacklight::RequestBuilders

  def author_docs(cris_id)
    return unless cris_id
    result = Blacklight.solr.get('ddf_publ', params: {
      q: "cris_id_ss:#{cris_id}",
      fq: 'access_ss:ddf_publ AND NOT format:person',
      wt: 'json',
      fl: '*',
      rows: 10
      }
    )
    { size: result['response']['numFound'], docs: result['response']['docs'] }
  end
end
