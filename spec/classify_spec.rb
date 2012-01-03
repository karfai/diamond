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

describe 'Diamond::classify' do
  it "should classify issues" do
    expectations = {
      'GENERATION HOPE #14 XREGB' => {
        :type      => :issue,
        :series    => 'GENERATION HOPE',
        :number    => '14',
        :storyline => 'XREGB',
      },
      'BATMAN #4' => {
        :type      => :issue,
        :series => 'BATMAN',
        :number => '4',
      },
      'RED HOOD AND THE OUTLAWS #4' => {
        :type      => :issue,
        :series => 'RED HOOD AND THE OUTLAWS',
        :number => '4',
      },
      'LEGION OF MONSTERS #3 (OF 4)' => {
        :type      => :issue,
        :series => 'LEGION OF MONSTERS',
        :number => '3',
        :final_number => '4',
      },
      'DC COMICS PRESENTS BATMAN BLAZE OF GLORY #1' => {
        :type      => :issue,
        :series => 'DC COMICS PRESENTS BATMAN BLAZE OF GLORY',
        :number => '1',
      },
      'DMZ #72 (MR) (O/A)' => {
        :type      => :issue,
        :series => 'DMZ',
        :number => '72',
        :tags => [:mature_readers, :ordered_again],
      },
      'DMZ #72 (O/A) (MR)' => {
        :type      => :issue,
        :series => 'DMZ',
        :number => '72',
        :tags => [:ordered_again, :mature_readers],
      },
      'DETECTIVE COMICS #1 4TH PTG' => {
        :type      => :issue,
        :series => 'DETECTIVE COMICS',
        :number => '1',
        :printing => '4',
      },
      'DETECTIVE COMICS #1 4TH PTG (O/A) (MR)' => {
        :type      => :issue,
        :series => 'DETECTIVE COMICS',
        :number => '1',
        :printing => '4',
        :tags => [:ordered_again, :mature_readers],
      },
      'FABLES #112 (MR) (NOTE PRICE)' => {
        :type   => :issue,
        :series => 'FABLES',
        :number => '112',
        :tags   => [:mature_readers, :price_change],
      },
      'END OF NATIONS #2 (OF 4) (RES)' => {
        :type   => :issue,
        :series => 'END OF NATIONS',
        :number => '2',
        :final_number => '4',
        :tags => [:resubmitted],
      },
      'UNWRITTEN #32.5 (MR)' => {
        :type => :issue,
        :series => 'UNWRITTEN',
        :number => '32.5',
        :tags => [:mature_readers],
      },
    }

    expectations.each do |src, ex|
      called = false
      Diamond::classify(src) do |ac|
        ac.should == ex
        called = true
      end.should == ex
      
      called.should be_true
    end
  end

  it "should classify trades" do
    expectations = {
      # atypical TP/VOL expression
      'LIL DEPRESSED BOY TP VOL 00' => {
        :type   => :tpb,
        :title  => 'LIL DEPRESSED BOY',
        :volume => '0',
      },
      # DARK HORSE style
      'BALTIMORE VOL 01 THE PLAGUE SHIPS TP' => {
        :type   => :tpb,
        :series => 'BALTIMORE',
        :title  => 'THE PLAGUE SHIPS',
        :volume => '1',
      },
      'SOLOMON KANE TP VOL 03 RED SHADOWS' => {
        :type   => :tpb,
        :series => 'SOLOMON KANE',
        :title  => 'RED SHADOWS',
        :volume => '3',
      },
      # DC style
      'TINY TITANS TP VOL 06 THE TREEHOUSE AND BEYOND' => {
        :type   => :tpb,
        :series => 'TINY TITANS',
        :title  => 'THE TREEHOUSE AND BEYOND',
        :volume => '6',
      },
      'HOUSE OF MYSTERY TP VOL 07 CONCEPTION (MR)' => {
        :type   => :tpb,
        :series => 'HOUSE OF MYSTERY',
        :title  => 'CONCEPTION',
        :volume => '7',
        :tags   => [:mature_readers],
      },
      # MARVEL style
      'CAPTAIN AMERICA AND BUCKY PREM HC LIFE OF BUCKY BARNES' => {
        :type => :hc,
        :series => 'CAPTAIN AMERICA AND BUCKY',
        :title => 'LIFE OF BUCKY BARNES',
      },
      'SECRET AVENGERS TP VOL 02 EYES OF DRAGON' => {
        :type => :tpb,
        :series => 'SECRET AVENGERS',
        :title => 'EYES OF DRAGON',
        :volume => '2',
      },
      'SECRET AVENGERS HC VOL 02 EYES OF DRAGON' => {
        :type => :hc,
        :series => 'SECRET AVENGERS',
        :title => 'EYES OF DRAGON',
        :volume => '2',
      },
    }

    expectations.each do |src, ex|
      called = false
      Diamond::classify(src) do |ac|
        ac.should == ex
        called = true
      end.should == ex
      
      called.should be_true
    end
  end
end
