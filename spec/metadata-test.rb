$LOAD_PATH << './src'

require 'metadata'
require 'date'

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
    
    it 'has a created at date' do
      date = DateTime::now
      @m['CreatedAt'].should == nil
      @m.created_at = date
      @m.created_at.should == date.to_s
      @m['CreatedAt'].should == date.to_s
    end

    it 'has a modified at date' do
      date = DateTime::now
      @m['ModifiedAt'].should == nil
      @m.modified_at = date
      @m.modified_at.should == date.to_s
      @m['ModifiedAt'].should == date.to_s
    end
  end

  context 'metadata helpers' do
    it 'can automatically set dates' do
      @m.modified_at.should be_nil
      @m.created_at.should be_nil
      @m.set_dates
      @m.modified_at.should_not be_nil
      @m.created_at.should_not be_nil
    end
  end
end
