require 'diamond'
require 'date'

describe 'Diamond::url_for_date' do
  it 'should handle the current new releases' do
    called = false
    Diamond::url_for_date(:current) do |url|
      called = true
      url.should == 'http://www.previewsworld.com/shipping/newreleases.txt'
    end
    called.should be_true
  end

  it 'should handle archived releases' do
    {
      '2010-11-12' => 'http://www.previewsworld.com/Archive/GetFile/1/1/71/994/111210.txt',
      '2011-03-04' => 'http://www.previewsworld.com/Archive/GetFile/1/1/71/994/030411.txt'
    }.each do |dts, ex|
      called = false
      Diamond::url_for_date(Date.parse(dts)) do |url|
        called = true
        url.should == ex
      end
      called.should be_true
    end
  end
end
