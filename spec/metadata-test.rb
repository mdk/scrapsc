require 'metadata'

describe 'Metadata' do

  before(:each) do
    @m = Metadata::new
  end

  context 'basic metadata' do
    it 'can be created' do
      @m.should_not be_nil
    end
  end

  context 'metadata snips' do
    it 'has title' do
      @m['Title'].should == nil
      @m.title = "This is title"
      @m.title.should == 'This is title'
      @m['Title'].should == 'This is title'
    end

    it 'has nick' do
      @m['Nick'].should == nil
      @m.nick = "nnn"
      @m.nick.should == 'nnn'
      @m['Nick'].should == 'nnn'
    end
  end
end
