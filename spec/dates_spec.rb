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
require 'diamond'
require 'date'

describe 'Diamond::current_release_date' do
  it "should determine the current release date for a specific date" do
    expectations = {
      # mon (before 1800), should be the preceeding wed
      Time.new(2012, 1, 2, 13, 0) => Date.new(2011, 12, 28),
      # mon (after 1800), should be the following wed
      Time.new(2012, 1, 2, 18, 10) => Date.new(2012, 1, 4),
      # tues, should be the following wed
      Time.new(2012, 1, 3) => Date.new(2012, 1, 4),
      # wed, should be today
      Time.new(2012, 1, 4) => Date.new(2012, 1, 4),
      # thu, should be the preceeding wed
      Time.new(2012, 1, 5) => Date.new(2012, 1, 4),
      # fri, should be the preceeding wed
      Time.new(2012, 1, 6) => Date.new(2012, 1, 4),
      # sat, should be the preceeding wed
      Time.new(2012, 1, 7) => Date.new(2012, 1, 4),
      # sun, should be the preceeding wed
      Time.new(2012, 1, 8) => Date.new(2012, 1, 4),
    }
    expectations.each do |t, dt|
      Diamond::current_release_date(t).should == dt
    end
  end
end
