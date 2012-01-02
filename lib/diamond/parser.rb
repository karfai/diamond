require 'date'

module Diamond
  def self.parse_line(ln, c)
    m = /^Shipping ([0-9]{2})\/([0-9]{2})\/([0-9]{4})/.match(ln)
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

  def self.classify_special_tag(tag)
    m = /OF ([0-9]+)/.match(tag)
    return { :final_number => m[1].to_i } if m
  end

  def self.classify_extras(s)
    tag_map = {
      'O/A' => :ordered_again,
      'MR'  => :mature_readers,
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

    if rv.empty?
      rv[:storyline] = s.strip if s.length && tags.empty?
      rv[:tags] = tags if !tags.empty?
    end

    rv
  end
end
