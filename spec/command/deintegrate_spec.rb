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

  $?.should.be.success
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

    it 'deintegrates a particular target' do
      path = fixture_project('StaticLibraries/TestProject.xcodeproj')
      project = Xcodeproj::Project.open(path)
      target = project.native_targets.find { |t| t.name == 'TestProject' }
      deintegrator = Deintegrator.new
      deintegrator.deintegrate_target(target)

      target.frameworks_build_phase.files.select { |f| f.display_name =~ /Pods/ }.should.be.empty
      target.shell_script_build_phases.select { |p| p.name =~ /Pods/ }.should.be.empty
      target.build_configurations.reject { |c| c.base_configuration_reference.nil? }.should.be.empty
    end
  end
end
