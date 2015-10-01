class PagesController < ApplicationController
  include StatService

  def index
    # @types = [
    #   { value: "dja", hits: 367796, label: "Journal article" },
    #   { value: "dba", hits: 88849,  label: "Book chapter"},
    #   { value: "dcp", hits: 85135,  label: "Conference paper" },
    #   { value: "dca", hits: 49126,  label: "Conference abstract" },
    #   { value: "db",  hits: 37094,  label: "Book" },
    #   { value: "dr",  hits: 33567,  label: "Report" },
    #   { value: "dna", hits: 20720,  label: "Newspaper article" },
    #   { value: "dco", hits: 20005,  label: "Conference poster" },
    #   { value: "do",  hits: 17755,  label: "Other" },
    #   { value: "dtp", hits: 16809,  label: "Thesis PhD" },
    #   { value: "dw",  hits: 12919,  label: "Working paper" },
    #   { value: "djb", hits: 10198,  label: "Journal book review" },
    #   { value: "dra", hits: 9340,   label: "Report chapter" },
    #   { value: "dbp", hits: 8311,   label: "Book preface" },
    #   { value: "djr", hits: 5978,   label: "Journal review article" },
    #   { value: "dln", hits: 2586,   label: "Lecture notes" },
    #   { value: "djc", hits: 2462,   label: "Journal comment" },
    #   { value: "dp",  hits: 1487,   label: "Patent" },
    #   { value: "dtd", hits: 748,    label: "Thesis Doctoral" },
    #   { value: "dd",  hits: 719,    label: "Data set" },
    #   { value: "dso", hits: 173,    label: "Software" }
    # ]

    @types = publications_by_facet('format_orig_s')
    @institutions = publications_by_facet('source_ss')

    # @meth = Blacklight.solr.public_methods

    # For making the link destinations (chosen facets):
    # link_to 'label', f[format_orig_s][]=dja
    # link_to 'label', catalog_index_path(:f => {:format_orig_s => ['dja']})
  end

  # def data
  #   respond_to do |format|
  #     format.json { render :json => [1, 2, 3, 4, 5] }
  #   end
  # end

  # SEARCH
  def search
    render :layout => 'search'
  end

  # OPEN ACCESS
  def open_access
    render :layout => 'open_access'
  end

  # ELITEFORSK AWARD
  def eliteforsk_award
    render :layout => 'eliteforsk_award'
  end

  # ABOUT
  def about
    render :layout => 'about'
  end

  def search_and_get
    render :layout => 'about'
  end

  def data
    render :layout => 'about'
  end

  def faq
    render :layout => 'about'
  end

  def contact
    render :layout => 'about'
  end

  # OTHER
  def pattern_library
    render :layout => 'chrome'
  end

  def feedback
    render :layout => 'chrome'
  end
end
