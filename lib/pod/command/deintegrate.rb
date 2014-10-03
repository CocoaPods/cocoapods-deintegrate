module Pod
  class Command
    class Deintegrate < Command
      self.summary = 'Deintegrate CocoaPods from your project.'
      self.description = <<-DESC
        Deintegrate your project from CocoaPods. Removing all traces
        of CocoaPods from your Xcode project.

        If no xcodeproj is specified, then a search for an Xcode project
        will be made in the current directory.
      DESC
      self.arguments = [
        CLAide::Argument.new('XCODE_PROJECT', false)
      ]

      def initialize(argv)
        path = argv.shift_argument()
        @project_path = Pathname.new(path) if path
        super
      end

      def validate!
        super

        unless @project_path
          xcodeprojs = Pathname.glob('*.xcodeproj')
          @project_path = xcodeprojs.first if xcodeprojs.size == 1
        end

        help! 'A valid Xcode project file is required.' unless @project_path
        help! "#{@project_path} does not exist." unless @project_path.exist?
        help! "#{@project_path} is not a valid Xcode project." unless @project_path.directory? && (@project_path + 'project.pbxproj').exist?
      end

      def run
        # We don't traverse a Podfile and try to de-intergrate each target.
        # Instead, we're just deintegrating anything CP could have done to a
        # project. This is so that it will clean stale, and modified projects.

        UI.puts("Deintegrating #{@project_path.basename}".green)

        project = Xcodeproj::Project.open(@project_path)
        deintegrate_project(project)
        project.save()

        pods_directory = config.sandbox.root
        if pods_directory.exist?
          UI.puts("Removing `#{pods_directory.relative_path_from(Dir.pwd)}` directory.")
          pods_directory.rmtree()
        end

        UI.puts('')
        UI.puts('Project has been deintegrated. No traces of CocoaPods left in project.'.green)
        UI.puts('Note: The workspace referencing the Pods project still remains.')
      end

    private

      def deintegrate_project(project)
        project.targets.each do |target|
          UI.section("Deintegrating target #{target.name}") do
            deintegrate_target(target)
          end

          delete_pods_file_references(project)
        end
      end

      def delete_pods_file_references(project)
        # The following implementation goes for files and empty groups so it
        # should catch cases where a user has changed the structure manually.

        groups = project.main_group.recursive_children_groups
        groups << project.main_group

        pod_files = groups.map do |group|
          group.files.select do |obj|
            obj.name =~ /^Pods.*\.xcconfig$/i or obj.path =~ /^libPods.*\.a$/i
          end
        end.flatten

        unless pod_files.empty?
          UI.puts('Deleting Pod file references from project')

          pod_files.each do |file_reference|
            UI.puts("- #{file_reference.name || file_reference.path}")
            file_reference.remove_from_project
          end
        end

        # Delete empty `Pods` directory if exists
        pod_groups = project.main_group.recursive_children_groups.select do |group|
          group.name == 'Pods' && group.children.empty?
        end

        unless pod_groups.empty?
          pod_groups.each(&:remove_from_project)
          UI.puts "Deleted #{pod_groups.count} `Pod` groups from project."
        end
      end

      def deintegrate_target(target)
        deintegrate_shell_script_phase(target, 'Copy Pods Resources')
        deintegrate_shell_script_phase(target, 'Check Pods Manifest.lock')
        deintegrate_pods_libraries(target)
      end

      def deintegrate_pods_libraries(target)
        frameworks_build_phase = target.frameworks_build_phase

        pods_build_files = frameworks_build_phase.files.select do |build_file|
          build_file.display_name =~ /^libPods.*\.a$/i
        end

        unless pods_build_files.empty?
          UI.puts('Removing Pod libraries from build phase:')

          pods_build_files.each do |build_file|
            UI.puts("- #{build_file.display_name}")
           frameworks_build_phase.remove_build_file(build_file)
          end
        end
      end

      def deintegrate_shell_script_phase(target, phase_name)
        phases = target.shell_script_build_phases.select do |phase|
          phase.name == phase_name
        end

        unless phases.empty?
          phases.each do |phase|
            target.build_phases.delete(phase)
          end

          UI.puts("Deleted #{phases.count} '#{phase_name}' build phases.")
        end
      end
    end
  end
end
