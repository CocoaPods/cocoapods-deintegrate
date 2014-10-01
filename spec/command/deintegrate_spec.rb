require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Deintegrate do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(['deintegrate']).should.be.instance_of Command::Deintegrate
      end
    end

    before do
      @command = Command.parse(['deintegrate'])
    end
  end
end

