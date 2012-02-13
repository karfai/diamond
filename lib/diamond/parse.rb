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
require 'date'

module Diamond
  def self.parse_line(ln, c)
    m = /^Shipping ([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})/.match(ln)
    if m
      c.shipping_date(Date.new(m[3].to_i, m[1].to_i, m[2].to_i))
    end

    m = /^([A-Z]+(\s[A-Z]+)*)\r$/.match(ln)
    if m
      c.section(m[1])
    end

    m = /^([A-Z]{3}[0-9]{6})\t([^\t]+)\t\$([0-9]+\.[0-9]+)\r$/.match(ln)
    if m
      c.item({:code => m[1], :desc => m[2], :price => m[3]})
    end
  end
  
  def self.parse(fn, c)
    File.open(fn) do |f|
      f.each { |ln| parse_line(ln, c) }
    end
  end
end
