MRuby::Build.new do |conf|
  # load specific toolchain settings

  # Gets set by the VS command prompts.
  if ENV['MRUBY_TOOLCHAIN']
    toolchain ENV['MRUBY_TOOLCHAIN']
  elsif ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  # enable_debug

  # use mrbgems
  Dir.glob("../mruby-*/mrbgem.rake") do |x|
    g = File.basename File.dirname x
    if g == 'mruby-onig-regexp'
      conf.gem "../deps/#{g}" do |c|
        c.bundle_onigmo
      end
    else
      conf.gem "../deps/#{g}"
    end
  end

  # include all the core GEMs
  conf.gembox 'full-core'
  conf.cc.flags << (ENV['CFLAGS'] || %w(-g -O3 -Wall -Werror-implicit-function-declaration -freg-struct-return -fomit-frame-pointer))
  conf.linker.flags << (ENV['LDFLAGS'] || %w(-lm))
  conf.linker.libraries << "stdc++"
  conf.cxx.flags << (ENV['CFLAGS'] || %w(-g -O3 -Wall -Werror-implicit-function-declaration -freg-struct-return -fomit-frame-pointer -fno-operator-names))
  conf.cxx.flags << %w(-fno-operator-names)
  conf.cxx.include_paths << "#{root}/xbyak"

end
