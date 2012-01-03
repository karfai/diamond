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

  def self.extract_tags(s)
    tag_map = {
      'O/A' => :ordered_again,
      'MR'  => :mature_readers,
      'NOTE PRICE' => :price_change,
      'RES' => :resubmitted,
    }

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

    rv[:tags] = tags if !tags.empty?

    rv
  end

  def self.extract_extras(s, &extra_fn)
    rv = {}
    m = /([0-9]+)\w+ PTG/.match(s)
    if m
      rv[:printing] = m[1]
    else
      extra_fn.call(s) if s
    end

    rv
  end

  def self.classify_extras(raw_s, &extra_fn)
    s = raw_s.strip
    rv = {}

    if s.index('(')
      m = /(?:([^\(]+) )?(.+)/.match(s)
      tags = self.extract_tags(m[2])
      rv = rv.merge(tags)
      s = m[1]
    end

    extras = self.extract_extras(s, &extra_fn)
    rv.merge(extras)
  end

  def self.classify_issue(s)
    rv = nil
    m = /([^\#]+)\s\#([0-9]+(?:\.[0-9]+)?)(?:\s(.+))?/.match(s)

    if m
      rv = { :type => :issue, :series => m[1], :number => m[2] }
      if m[3]
        extras = classify_extras(m[3]) do |s|
          rv[:storyline] = s if s.length
        end
        rv = rv.merge(extras)
      end
    end
    
    rv
  end

  def self.classify_trade_type(s)
    types = { 'TP' => :tpb, 'HC' => :hc }
    types.key?(s) ? types[s] : s
  end

  def self.extract_trade(s)
    rv = nil

    # the typical current format
    m = /(.+)(?: (TP|HC){1} )VOL ([0-9]+)(?: (.+))?/.match(s)
    if m
      rv = {
        :type   => classify_trade_type(m[2]),
        :volume => m[3].to_i.to_s,
        :title  => m[1],
      }
      if m[4]
        rv[:series] = m[1]
        rv[:title] = m[4]
      end
    end

    # sometimes the "TP" is at the end
    m = /(.+) VOL ([0-9]+) (.+)\sTP/.match(s)
    if m && !rv
      rv = { :type => :tpb, :series => m[1], :title => m[3], :volume => m[2].to_i.to_s }
    end

    # hardcovers
    m = /(.+) (?:PREM)? HC (.+)/.match(s)
    if m && !rv
      rv = { :type => :hc, :series => m[1], :title => m[2] }
    end

    rv
  end

  def self.classify_trade(s)
    rv = nil
    extras = classify_extras(s) do |rem|
      rv = extract_trade(rem)
    end
 
    rv.merge(extras)
  end

  def self.classify(s, &bl)
    rv = classify_issue(s) || classify_trade(s)
    yield(rv) if rv && bl
    rv
  end
end
