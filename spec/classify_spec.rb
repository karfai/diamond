require 'diamond'
require 'date'

describe 'Diamond::classify' do
  it "should classify issues" do
    expectations = {
      'GENERATION HOPE #14 XREGB' => {
        :type      => :issue,
        :series    => 'GENERATION HOPE',
        :number    => 14,
        :storyline => 'XREGB',
      },
      'BATMAN #4' => {
        :type      => :issue,
        :series => 'BATMAN',
        :number => 4,
      },
      'RED HOOD AND THE OUTLAWS #4' => {
        :type      => :issue,
        :series => 'RED HOOD AND THE OUTLAWS',
        :number => 4,
      },
      'LEGION OF MONSTERS #3 (OF 4)' => {
        :type      => :issue,
        :series => 'LEGION OF MONSTERS',
        :number => 3,
        :final_number => 4,
      },
      'DC COMICS PRESENTS BATMAN BLAZE OF GLORY #1' => {
        :type      => :issue,
        :series => 'DC COMICS PRESENTS BATMAN BLAZE OF GLORY',
        :number => 1,
      },
      'DMZ #72 (MR) (O/A)' => {
        :type      => :issue,
        :series => 'DMZ',
        :number => 72,
        :tags => [:mature_readers, :ordered_again],
      },
      'DMZ #72 (O/A) (MR)' => {
        :type      => :issue,
        :series => 'DMZ',
        :number => 72,
        :tags => [:ordered_again, :mature_readers],
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

  pending "should classify trades"
end
