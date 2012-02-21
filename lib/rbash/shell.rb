require 'readline'
require 'erb'

module Rbash
  class Shell
    def initialize
      @cmds = Rbash::ShellCmds.new
      reload!
    end

    def reload!
      @os = `uname`
      @ps1 = '[{USER} {PWD}]$ '
    end

    def prompt
      path = Dir.pwd.gsub(ENV['HOME'], '~')
      @ps1.gsub('{PWD}', path).gsub('{USER}', ENV['USER'])
    end

    def start(cwd='.')
      run("cd #{cwd}")
      while line = Readline.readline(prompt, true)
        run(line)
      end
    end

    def run(cmd)
      erb = ERB.new(cmd, nil, '%<>')
      cmd = erb.result(@cmds.get_binding)

      return if cmd.nil? or cmd.empty?
      s = cmd.split(/\s+/)

      if @cmds.respond_to? s.first.to_sym
        @cmds.send(s.shift, s)
      else
        output = eval(cmd, @cmds.get_binding)
      end
      puts "=> #{output.inspect}" unless output.nil?
    rescue NameError, SyntaxError, ArgumentError, NoMethodError => e
      unless system_exec(cmd)
        puts "Exception: #{e.message} (#{e.class})"
      end
    rescue Exception => e
      raise e if e.class == SystemExit
      puts "Exception: #{e.message} (#{e.class})"
      puts e.backtrace
    end

    def system_exec(cmd)
      system cmd
    end
  end
end
