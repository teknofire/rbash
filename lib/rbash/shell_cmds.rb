require 'readline'

module Rbash
  class ShellCmds
    include Rbash::Builtins

    def get_binding
      return binding()
    end
  end
end
