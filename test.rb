require 'rubygems'
require 'scrap'
require 'spec'
require 'storage'

describe 'Storage' do
  before(:each) do
    @db = TDB::new
    @db.open('test.tct', TDB::OWRITER | TDB::OCREAT)
    @db.vanish
    @st = Storage::new(@db)
  end

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

  after(:each) do
    @st.close
  end
end

describe 'Scrap' do

  before(:each) do
    @s = Scrap::new
  end

  it "can be created" do
    @s.should_not be_nil
  end

  it "has a settable content" do
    @s.content = "This is content"
    @s.content.should == "This is content"
  end

  it "has a settable metadata" do
    @s.metadata['Title'] = "TitleOne"
    @s.metadata['Nick'] = "nick"
    @s.metadata['Title'].should == "TitleOne"
    @s.metadata['Nick'].should == "nick"
  end

  it 'is fresh by default' do
    @s.fresh?.should be_true
  end

  it 'is not saved by default' do
    @s.saved?.should_not be_true
  end

  it "can be serialized to keys" do
    @s.content = "Hello"
    @s.remote_id = 'AAA'
    @s.revision = 3
    @s.metadata['Title'] = "TitleOne"
    @s.metadata['Nick'] = "nick"
    
    data = @s.to_db_keys

    data.should_not be_nil
    data['content'].should == "Hello"
    data['remote_id'].should == "AAA"
    data['revision'].should == "3"
    data['metadata:Title'].should == 'TitleOne'
    data['metadata:Nick'].should == 'nick'
  end

  it 'truly serializes to strings' do
    @s.revision = 3
    
    data = @s.to_db_keys
    
    data.should_not be_nil
    data['revision'].should_not == 3
  end

  it "when serialized, nil is not put" do
    data = @s.to_db_keys
    data['remote_id'].should == ''
    data['content'].should == ''
    data['revision'].should == '1'
  end

  it 'can unserialize from db keys' do
    data = { 'remote_id' => 'BBB', 
             'revision' => '67', 
             'content' => 'HelloWorld' }
    @s.from_db_keys('567', data)
  
    @s.local_id.should == '567'
    @s.remote_id.should == 'BBB'
    @s.revision.should == 67
    @s.content.should == 'HelloWorld'
  end

  it 'can unserialize metadata too' do
   data = { 'remote_id' => 'CCC', 
            'revision' => '87', 
            'content' => 'HelloWorld', 
            'metadata:Title' => 'Hello', 
            'metadata:Another' => 'Another' }
    @s.from_db_keys('666', data)
    
    @s.local_id.should == '666'
    @s.remote_id.should == 'CCC'
    @s.revision.should == 87
    @s.content.should == 'HelloWorld'
    @s.metadata['Title'].should == 'Hello'
    @s.metadata['Another'].should == 'Another'
  end

end
