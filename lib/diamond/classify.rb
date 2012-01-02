module Diamond  
  def self.classify_issue(s)
    rv = nil
    m = /([^\#]+)\s\#([0-9]+)(?:\s(.+))?/.match(s)
    
    if m
      rv = { :type => :issue, :series => m[1], :number => m[2].to_i }
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
