//= require spotlight/blocks/resources_block

SirTrevor.Blocks.Search = (function(){

  return SirTrevor.Block.extend({
    type: "search",
    formable: true,

    title: function() { return i18n.t('blocks:search:title'); },
    description: function() { return i18n.t('blocks:search:description'); },


    icon_name: "pages",
    blockGroup: function() { return i18n.t("blocks:group:items") },

    editorHTML: function() {
      return _.template(this.template, this)(this);
    },

    template: [
      '<div class="clearfix">',
        '<div class="widget-header">',
          '<%= description() %>',
        '</div>',
        '<p>Show 25 most recent publications</p>',
      '</div>'
    ].join("\n"),
  });

})();

SirTrevor.Locales.en.blocks.search = {
  title:  "Publications",
  description: "Show a select sample of publications",
};

