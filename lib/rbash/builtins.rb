require 'readline'

module Rbash
  module Builtins
    def exit(params='')
      Kernel.exit
    end

    def cd(h)
      path = File.join(h).gsub('~', ENV['HOME'])
      path = ENV['HOME'] if path.nil? or path.empty?

      Dir.chdir(path) 
    end

    def ls(h)
      system("ls --color #{h.join(' ')}")
    end
  end
end
