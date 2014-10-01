module Pod
  class Command
    class Deintergrate < Command
      self.summary = 'De-intergrate CocoaPods from your project.'

      def validate!
        super

        xcodeprojs = Pathname.glob('*.xcodeproj')
        if xcodeprojs.size == 1
          @project_path = xcodeprojs.first
        else
          # TODO ask user to define project as argument
          raise Informative, 'Could not find a valid project file.'
        end
      end

      def run
        # We don't traverse a Podfile and try to de-intergrate each target.
        # Instead, we're just deintergrating anything CP could have done to a
        # project. This is so that it will clean stale, and modified projects.

        UI.puts("Deintergrating #{@project_path.basename}".green)

        project = Xcodeproj::Project.open(@project_path)
        deintergrate_project(project)
        project.save()

        UI.puts('')
        UI.puts('Project has been deintergrated. No traces of CocoaPods left in project.'.green)
      end

    private

      def deintergrate_project(project)
        project.targets.each do |target|
          UI.section("Deintergrating target #{target.name}") do
            deintergrate_target(target)
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

      def deintergrate_target(target)
        deintergrate_shell_script_phase(target, 'Copy Pods Resources')
        deintergrate_shell_script_phase(target, 'Check Pods Manifest.lock')
        deintergrate_pods_libraries(target)
      end

      def deintergrate_pods_libraries(target)
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

      def deintergrate_shell_script_phase(target, phase_name)
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

