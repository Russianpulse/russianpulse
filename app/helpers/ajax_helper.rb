module AjaxHelper
  def ajax_block(url)
    id = "ajax-#{rand.to_s.sub('.', '')}"
    capture do
      concat content_tag(:div, nil, id: id)
      concat javascript_tag("$('##{id}').load('#{url}');")
    end
  end
end
