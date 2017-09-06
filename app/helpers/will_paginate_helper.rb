module WillPaginateHelper
  class WillPaginateAjaxLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def prepare(collection, options, template)
      options[:params] ||= {}
      options[:params]["_"] = nil
      options[:next_label] = '<i class="fa fa-chevron-right"></i>'
      options[:previous_label] = '<i class="fa fa-chevron-left"></i>'
      options[:inner_window] = 2
      options[:outer_window] = -1
      options[:gap] = '...'
      super(collection, options, template)
    end

    protected
      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          target = url(target)
        end
        # @template
        ajax_call = "$.ajax({url: '#{target}', dataType: 'script'});"
        @template.link_to(text.to_s.html_safe, '#', attributes.merge(:onclick => "#{ajax_call} event.preventDefault();"))
      end
  end

  def ajax_will_paginate(collection, options = {})
    will_paginate(collection, options.merge(:renderer => WillPaginateHelper::WillPaginateAjaxLinkRenderer))
  end
end
