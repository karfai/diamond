# Copyright 2012 Don Kelly <karfai@gmail.com>

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
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
    begin
      url_for_date(dt) do |url|
        open(url) { |f| yield(f) }
      end
    rescue SocketError
    end
  end
end
