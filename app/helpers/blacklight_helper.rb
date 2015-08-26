# 23.07.2015: Here or in CatalogHelper?
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Override blacklight document actions to exclude 'Folder' and 'Bookmarks'
  # and instead render 'Tagging' functionality
  # def render_index_doc_actions (document, options={})
  #   wrapping_class = options.delete(:wrapping_class) || "index-document-functions"

  #   content = []
  #   content << render_tag_control(document) if can? :tag, Bookmark
  #   content_tag("div", content.join("\n").html_safe, :class => wrapping_class) unless content.empty?
  # end

  # def render_tag_control(document)
  #   bookmark = current_user.bookmarks.find_by_document_id(document.id)
  #   tags = bookmark ? bookmark.tags.order(:name) : []
  #   tags = current_user.tags.order(:name)

  #   return_url = request.url
  #   if params && params[:return_url]
  #     return_url = params[:return_url]
  #   end

  #   render 'tags/tag_control',
  #   {:document => document, :document_id => document.id, :bookmark => bookmark, :tags => tags, :return_url => return_url}
  # end

  # TODO
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



