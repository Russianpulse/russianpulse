module I18nHelper
  def plural(count, single, plural2 = nil, _plural5 = nil)
    if count == 1
      single
    else
      plural2 || single.pluralize
    end
  end
end
