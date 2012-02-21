require 'readline'

module Rbash
  class Base
    def initialize
      @shell = Shell.new
      @ps1 = "[{USER} {PWD}]$ "
    end

    def prompt
      path = Dir.pwd.gsub(ENV['HOME'], '~')
      @ps1.gsub('{PWD}', path).gsub('{USER}', ENV['USER'])
    end

    def start
      @stty_save = `stty -g`.chomp
      
      @shell.run('cd ~')
      while line = Readline.readline(prompt, true)
        @shell.run(line)
      end
    rescue Interrupt => e
      print "\n"
      retry
      #system('stty', @stty_save) #Restore
      #exit
    end
  end
end
