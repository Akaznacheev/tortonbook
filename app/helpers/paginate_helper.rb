require 'will_paginate/view_helpers/link_renderer'
require 'will_paginate/view_helpers/action_view'
module PaginateHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag(:nav, tag(:ul, html, class: 'pagination'))
    end

    def previous_or_next_page(page, text, _classname)
      if page
        tag(:li, link(text, page, class: 'page-link'), class: 'page-item')
      else
        tag(:li, tag(:a, text, class: 'page-link'), class: 'page-item disabled')
      end
    end

    def page_number(page)
      if page == current_page
        tag(:li, tag(:a, page, class: 'page-link'), class: 'page-item active')
      else
        tag(:li, link(page, page, class: 'page-link'), class: 'page-item')
      end
    end

    def gap
      tag(:li, tag(:a, '&hellip;', class: 'page-link'), class: 'page-item disabled')
    end
  end

  def bs_will_paginate(collection = nil, options = {})
    if collection.is_a? Hash
      options = collection
      collection = nil
    end
    options = options.merge(
      renderer: PaginateHelper::LinkRenderer,
      previous_label: '&laquo;',
      next_label: '&raquo;'
    )
    will_paginate(collection, options)
  end
end
