require 'open-uri'

module Diamond
  def self.url_for_date(dt)
    if dt == :current
      yield('http://www.previewsworld.com/shipping/newreleases.txt')
    else
      yield(dt.strftime('http://www.previewsworld.com/Archive/GetFile/1/1/71/994/%m%d%y.txt'))
    end
  end

  def self.download(dt)
    url_for_date(dt) do |url|
      open(url) { |f| yield(f) }
    end
  end
end
