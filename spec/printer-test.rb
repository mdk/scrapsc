require 'printer'

describe "Printer" do
  before (:each) do
    @p = Printer::new
  end

  context 'printer helpers' do
    it 'can normalize a title' do
      @p.normalize_title("This").should == "This"
      @p.normalize_title(nil).should == "(Undefined)"
      @p.normalize_title('').should == '(Undefined)'
    end

    it 'has a list char' do
      @p.list_char.should == "*"
    end

    it 'generates nice dates' do
      minute = 1.0 / (24 * 60.0)
      @p.generate_date(DateTime::now - (minute * 5)).should == "~5m"
      @p.generate_date(DateTime::now - (minute * 40)).should == "~40m"
      @p.generate_date(DateTime::now - (minute * 41)).should == "~1h"
      @p.generate_date(DateTime::now - (minute * 50)).should == "~1h"
      @p.generate_date(DateTime::now - (minute * 61)).should == "~1h"
      @p.generate_date(DateTime::now - (minute * 105)).should == "~2h"
      @p.generate_date(DateTime::now - (minute * 60 * 14)).should == "~1d"
      @p.generate_date(DateTime::now - 1).should == "~1d"
      @p.generate_date(DateTime::now - 5).should == "~5d"
      @p.generate_date(DateTime::now - 6).should == "~6d"
      @p.generate_date(DateTime::now - 7).should == "~1w"
      @p.generate_date(DateTime::now - 10).should == "~1w"
      @p.generate_date(DateTime::now - 11).should == "~2w"
      @p.generate_date(DateTime::now - 14).should == "~2w"
      @p.generate_date(DateTime::now - 15).should == "~3w"
    end
  end
end
