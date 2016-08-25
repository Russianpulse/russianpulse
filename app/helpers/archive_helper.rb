module ArchiveHelper
  def archive_date_classes(date)
    classes = [:date]

    classes << :holiday if holiday? date
    classes << :disabled if date.future?
    classes << :today if date.today?

    classes.join ' '
  end

  private

  def holiday?(date)
    date.sunday? || date.saturday?
  end
end
