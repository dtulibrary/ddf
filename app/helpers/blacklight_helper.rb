# 23.07.2015: Here or in CatalogHelper?
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # TODO
  def render_bookmark_toggle(document, options={})
    wrapping_class = options.delete(:wrapping_class) || "bookmark_document"

    bookmark = current_or_guest_user.bookmarks.find_by_document_id(document.id) # not required by partial
    return_url = params[:url] || request.url # not required by partial

    # binding.pry

    control = render('bookmark_control', :document => document)
    content_tag("div", control, :class => wrapping_class)
  end

  def render_index_doc_actions(document, options={})
    return_url = params[:url] || request.url
    actions = []
    actions << content_tag("li", render_cite_action(document, options={}))
    actions << content_tag("li", render_export_action(document, :return_url => return_url))
    wrapping_class = options.delete(:wrapping_class) || "document-actions-list"
    content_tag("ul", actions.join("\n").html_safe, :class => wrapping_class) unless actions.empty?
  end

  def render_cite_action(document, options={})
    if !document.citation_styles.blank?
      render('catalog/cite_button', :document => document)
    end
  end

  def render_export_action(document, options={})
    if document[:format] != "journal"
      render('catalog/export_button', :document => document, :return_url => options[:return_url])
    end
  end

  def citation_title document
    title = document[blacklight_config.show.title_field]
    (title.kind_of? Array) ? title.first : title
  end
end



