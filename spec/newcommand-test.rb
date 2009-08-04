require 'rubygems'
require 'newcommand'
require 'spec'

describe 'NewCommand' do
    context 'basic new command' do
      it 'can be created' do
        @w = NewCommand::new(['new'])
        @w.should_not be_nil
      end

      it "can't be created with invalid word" do
        lambda {
          NewCommand::new(['save'])
        }.should raise_error
      end
    end

    context 'walking new command' do
      it 'can walk a set with title' do
        @w = NewCommand::new(['new', 'some title'])
        @w.walk!
        @w.title.should == 'some title'
      end

      it 'requires a valid title' do
        @w = NewCommand::new(['new'])
        lambda { @w.walk! }.should raise_error
      end
    end
end

