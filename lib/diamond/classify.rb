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
module Diamond  
  def self.classify_special_tag(tag)
    m = /OF ([0-9]+)/.match(tag)
    return { :final_number => m[1] } if m
  end

  def self.classify_extras(raw_s)
    tag_map = {
      'O/A' => :ordered_again,
      'MR'  => :mature_readers,
      'NOTE PRICE' => :price_change,
      'RES' => :resubmitted,
    }

    s = raw_s.strip
    rv = {}
    tags = []

    s.scan(/\(([^\)]+)\)/).each do |t|
      tag = t[0]

      special_tag = classify_special_tag(tag)
      if special_tag
        rv = rv.merge(special_tag)
      else
        tags << (tag_map.key?(tag) ? tag_map[tag] : tag)
      end
    end

    m = /([0-9]+)\w+\sPTG/.match(s)
    if m
      rv[:printing] = m[1]
    end

    rv[:tags] = tags if !tags.empty?
    rv[:storyline] = s if s.length && rv.empty?

    rv
  end

  def self.classify_issue(s)
    rv = nil
    m = /([^\#]+)\s\#([0-9]+(?:\.[0-9]+)?)(?:\s(.+))?/.match(s)
    
    if m
      rv = { :type => :issue, :series => m[1], :number => m[2] }
      if m[3]
        rv = rv.merge(classify_extras(m[3]))
      end
    end
    
    rv
  end

  def self.classify(s)
    rv = classify_issue(s)
    yield(rv) if rv
    rv
  end
end
