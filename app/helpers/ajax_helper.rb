module AjaxHelper
  def ajax_block(url)
    id = "ajax-#{rand.to_s.sub('.', '')}"
    capture do
      concat content_tag(:div, nil, id: id)
      concat javascript_tag("$('##{id}').load('#{url}');")
    end
  end

  def ajax_cell(name, *args)
    ajax_block ajax_cell_path(name, args: args.to_json)
  end
end
