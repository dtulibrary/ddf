module Dtu::DocumentPresenter::Mendeley
  def mendeley_identifiers(solr_document)
    identifiers = {}
    identifiers[:doi]    = solr_document[:doi_ss].try(:first)
    identifiers[:issn]   = solr_document[:issn_ss].try(:first)
    identifiers[:isbn]   = solr_document[:isbn_ss].try(:first)
    identifiers[:scopus] = get_source_id(solr_document, :scopus)
    identifiers[:pmid]   = get_source_id(solr_document, :pubmed)
    identifiers[:arxiv]  = get_source_id(solr_document, :arxiv)
    identifiers.delete_if{ |k, v| v.blank? }
  end

  def get_source_id(solr_document, source)
    solr_document[:source_id_ss].find{|id| id.start_with?(source.to_s)}.try(:split, ':').try(:last)
  end
end