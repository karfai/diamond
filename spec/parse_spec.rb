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

describe 'Diamond::parse' do
  before(:each) do
    @callback = double()
    @callback.stub!(:section)
    @callback.stub!(:shipping_date)
    @callback.stub!(:item)
  end

  it "should parse the release date from a file" do
    expectations = {
      '2011-12-21' => { :file => 'spec/fuel/122111.txt' },
      '2011-12-28' => { :file => 'spec/fuel/122811.txt' },
      '2012-02-08' => { :file => 'spec/fuel/020812.txt' },
      '2012-09-05' => { :file => 'spec/fuel/new.txt' },
    }

   expectations.each do |k, v|
      @callback.should_receive(:shipping_date).with(Date.parse(k))
      
      Diamond::parse(v[:file], @callback)
    end
  end

  it "should parse sections" do
    expectations = {
      '2011-12-21' => {
        :file     => 'spec/fuel/122111.txt',
        :sections => ['DARK HORSE COMICS', 'DC COMICS', 'IDW PUBLISHING', 'IMAGE COMICS', 'MARVEL COMICS', 'COMICS', 'MAGAZINES', 'MERCHANDISE'],
      },
      '2011-12-28' => {
        :file     => 'spec/fuel/122811.txt',
        :sections => ['PREVIEWS PUBLICATIONS', 'DARK HORSE COMICS', 'DC COMICS', 'IDW PUBLISHING', 'IMAGE COMICS', 'MARVEL COMICS', 'COMICS', 'MAGAZINES', 'MERCHANDISE'],
      },
      '2012-09-05' => {
        :file     => 'spec/fuel/new.txt',
        :sections => ['PREMIER PUBLISHERS', 'DARK HORSE COMICS', 'DC COMICS', 'IDW PUBLISHING', 'IMAGE COMICS', 'MARVEL COMICS', 'COMICS & GRAPHIC NOVELS', 'MAGAZINES', 'BOOKS', 'MERCHANDISE'],
      }
    }

    expectations.each do |k, v|
      v[:sections].each { |sn| @callback.should_receive(:section).with(sn) }

      Diamond::parse(v[:file], @callback)
    end
  end

  it "should parse items" do
    expectations = {
      '2011-12-21' => {
        :file       => 'spec/fuel/122111.txt',
        :some_items => [{:code => 'AUG110039', :desc => 'BALTIMORE VOL 01 THE PLAGUE SHIPS TP', :price => '18.99'},
                        {:code => 'OCT110184', :desc => 'BATMAN #4', :price => '2.99'},
                        {:code => 'OCT110199', :desc => 'RED HOOD AND THE OUTLAWS #4', :price => '2.99' },
                        {:code => 'OCT110668', :desc => 'LEGION OF MONSTERS #3 (OF 4)', :price => '3.99' },
                        {:code => 'OCT110520', :desc => 'WALKING DEAD OMNIBUS NEW PTG HC VOL 02 (O/A) (MR)', :price => '100.00'},
                        ]
      },
      '2011-12-28' => {
        :file       => 'spec/fuel/122811.txt',
        :some_items => [{:code => 'OCT110237', :desc => 'DC COMICS PRESENTS BATMAN BLAZE OF GLORY #1', :price => '7.99'},
                        {:code => 'OCT110390', :desc => 'ANNE RICE SERVANT OF THE BONES #5 (OF 6)', :price => '3.99'},
                        {:code => 'OCT110729', :desc => 'SECRET AVENGERS TP VOL 02 EYES OF DRAGON', :price => '19.99'},
                        ]
      },
      '2011-09-05' => {
        :file       => 'spec/fuel/new.txt',
        :some_items => [{:code => 'JUL121425', :desc => 'SUPERNATURAL MAGAZINE #35 PX ED', :price => '9.99'},
                        {:code => 'JUL120142', :desc => 'ACTION COMICS #0', :price => '3.99'},
                        {:code => 'JUL120175', :desc => 'GREEN LANTERN #0 COMBO PACK', :price => '3.99'},
                        {:code => 'JUL120607', :desc => 'AGE OF APOCALYPSE #7', :price => '2.99'},
                        {:code => 'JUL120578', :desc => 'INVINCIBLE IRON MAN #524', :price => '3.99'},
                        ]
      }
    }

    expectations.each do |k, v|
      items = []
      @callback.stub(:item) { |it| items << it }

      Diamond::parse(v[:file], @callback)

      items.length.should be > v[:some_items].length
      v[:some_items].each { |it| items.should include(it) }
    end
  end
end
