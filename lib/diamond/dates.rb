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
require 'active_support/core_ext'

module Diamond
  def self.current_release_date(t)
    if t.wday == 0 || (t.wday == 1 && t.hour < 17)
      t -= (4 + t.wday).days
    elsif t.wday < 3
      t += (3 - t.wday).days
    elsif t.wday > 3
      t -= (t.wday - 3).days
    end

    Date.new(t.year, t.month, t.day)
  end
end
