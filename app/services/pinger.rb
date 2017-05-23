class Pinger
  def self.ping(url, title)
    uri = URI('http://ping.blogs.yandex.ru/RPC2')
    https = Net::HTTP.new(uri.host, uri.port)

    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <methodCall>
        <methodName>weblogUpdates.ping</methodName>
        <params>
          <param>
            <value>#{title}</value>
          </param>
          <param>
            <value>#{url}</value>
          </param>
        </params>
      </methodCall>
    XML

    response = https.post(uri.path, xml)
  end
end
