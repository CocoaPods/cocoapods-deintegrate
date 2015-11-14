ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$:.unshift((ROOT + 'lib').to_s)

require 'cocoapods'
require 'cocoapods_plugin'

require 'mocha'
require 'mocha-on-bacon'
require 'pretty_bacon'

module Pod
  module UI
    @output = ''
    @warnings = ''

    class << self
      attr_accessor :output
      attr_accessor :warnings

      def puts(message = '')
        @output << "#{message}\n"
      end

      def warn(message = '', _actions = [])
        @warnings << "#{message}\n"
      end
    end
  end
end
