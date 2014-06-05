require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Deintergrate do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(['deintergrate']).should.be.instance_of Command::Deintergrate
      end
    end

    before do
      @command = Command.parse(['deintergrate'])
    end

    it 'should error if you do not have a podfile in current directory' do
      should.raise Informative do
        @command.validate!
      end.message.should.match /Podfile/
    end
  end
end

