require 'rubygems'
require 'optwalkers'
require 'spec'

describe 'NewWalker' do
    context 'basic new walker' do
      it 'can be created' do
        @w = NewWalker::new(['new'])
        @w.should_not be_nil
      end

      it "can't be created with invalid action" do
        lambda {
          NewWalker::new(['save'])
        }.should raise_error
      end
    end

    context 'walking new walker' do
      it 'can walk a set with title' do
        @w = NewWalker::new(['new', 'some title'])
        @w.walk!
        @w.title.should == 'some title'
      end

      it 'requires a valid title' do
        @w = NewWalker::new(['new'])
        lambda { @w.walk! }.should raise_error
      end
    end
end

