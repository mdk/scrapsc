$LOAD_PATH << './src'

require 'rubygems'
require 'tokyocabinet'
require 'storage'
require 'spec'

include TokyoCabinet

describe 'Storage' do

  before(:each) do
    @db = TDB::new
    @db.open('test.tct', TDB::OWRITER | TDB::OCREAT)
    @db.vanish
    @st = Storage::new(@db)
  end

  context 'storage basic' do

    it 'can be created' do
      @st.should_not be_nil
    end

    it 'can save a non-saved scrap' do
      scrap = mock('Scrap')
      scrap.stub!(:saved?).and_return(false)
      scrap.stub!(:to_db_keys).and_return({'content' => 'Content', 'something' => 'Something'})
      scrap.should_receive(:local_id=).once
      @st << scrap
    end

    it 'can save a saved scrap' do
      scrap = mock('Scrap')
      scrap.stub!(:saved?).and_return(true)
      scrap.stub!(:local_id).and_return(666)
      scrap.stub!(:to_db_keys).and_return({'content' => 'Content'})
      scrap.should_not_receive(:local_id=)
      @st << scrap
      scrap.local_id.should == 666
      @db.get('666')['content'].should == 'Content'
    end
  end

  after(:each) do
    @st.close
  end
end

