require File.expand_path('../../spec_helper', __FILE__)

def fixture_project(named)
  ROOT + "spec/fixtures/Project/#{named}"
end

def temporary_directory
  ROOT + 'tmp'
end

def deintegrate(directory)
  Dir.chdir(directory) do
    command = Pod::Command.parse(['deintegrate'])
    command.config.sandbox.stubs(:root).returns(directory + 'Pods')
    command.validate!
    command.run
  end
end

def deintegrate_project(named)
  path = fixture_project(named)
  `rsync -r #{path}/ #{temporary_directory}`

  deintegrate(temporary_directory)

  (temporary_directory + 'TestProject.xcworkspace').rmtree
  (temporary_directory + 'Podfile').delete
  (temporary_directory + 'Podfile.lock').delete

  output = `diff -r #{fixture_project('None')} #{temporary_directory}`
  puts(output) unless $?.success?

  $?.success?.should == true
end

module Pod
  describe Command::Deintegrate do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(['deintegrate']).should.be.instance_of Command::Deintegrate
      end
    end

    before do
      temporary_directory.rmtree if temporary_directory.exist?
      temporary_directory.mkdir
    end

    after do
      temporary_directory.rmtree
    end

    it 'deintegrates a static library integrated project' do
      deintegrate_project('StaticLibraries')
    end

    it 'deintegrates a framework integrated project' do
      deintegrate_project('Frameworks')
    end
  end
end

