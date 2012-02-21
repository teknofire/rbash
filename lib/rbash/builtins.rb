require 'readline'

module Rbash
  module Builtins
    def exit(params='')
      Kernel.exit
    end

    def cd(h)
      path = File.join(h).gsub('~', $HOME)
      path = $HOME if path.nil? or path.empty?

      Dir.chdir(path) 
    end

    def ls(h)
      case $OS
      when "Darwin"
        ls = "ls -G"
      when "Linux" 
        ls = "ls --color"
      else
        ls = "ls"
      end

      system "#{ls} #{h.join(' ')}"
    end
  end
end
