module Pod
  class Command
    class Deintergrate < Command
      self.summary = 'De-intergrate CocoaPods from your project.'

      def validate!
        super
        verify_podfile_exists!
      end

      def run
        UI.puts 'Hello, this command isn\'t done yet!'
      end
    end
  end
end

