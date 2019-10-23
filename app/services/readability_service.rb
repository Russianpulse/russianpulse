class ReadabilityService
  def call(html, rules)
    # удаляем комментарии
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    doc.xpath('//comment()').remove
    html = doc.to_html

    (default_rules + rules).map(&:strip).each_with_index do |line, index|
      match = line.match(/^([^\s]+)\s+([^\s]+)\s+(.*)/)

      if match
        cmd = match[1]
        args = [match[2], match[3].strip]

        case cmd
        when 'remove'

          case args[0]
          when 'regexp'
            regexp = eval(args[1])

            html = html.remove regexp
          when 'css'
            doc = Nokogiri::HTML::DocumentFragment.parse(html)
            doc.css(args[1]).each(&:remove)

            html = doc.to_html
          else
            raise "unknown remove type '#{args[0]}': '#{line}'"
          end

        when 'select'
          case args[0]
          when 'css'
            doc = Nokogiri::HTML::DocumentFragment.parse(html)

            el = doc.css(args[1])[0]

            if el.present?
              html = doc.css(args[1])[0].to_html
            else
              raise "Can't find anything by css selector '#{args[1]}'"
            end
          else
            raise "unknown remove type '#{args[0]}': '#{line}'"
          end

        else
          raise "unknown cmd '#{cmd}'"
        end
      else
        raise "failed to parse line ##{index}: #{line}"
      end
    end

    html
  end

  private

  def default_rules
    rules = []

    rules << 'remove regexp /This entry passed through the Full-Text RSS service.+/im'
    rules << 'remove regexp /Let\'s block ads!/'
    rules << 'remove regexp /\(Why\?\)/'
    rules << 'remove css .feedflare'

    rules
  end
end
