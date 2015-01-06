require "formula"

class Luarocksjit < Formula
  homepage "http://luarocks.org"
  url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
  sha1 "e2de00f070d66880f3766173019c53a23229193d"
  revision 1

  head "https://github.com/keplerproject/luarocks.git"

  depends_on "luajit"

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    # Specify where the Lua is to avoid accidental conflict.
    lua_prefix = Formula["luajit"].opt_prefix

    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks",
            "--with-lua-include=#{HOMEBREW_PREFIX}/opt/luajit/include/luajit-2.0",
            "--with-lua=#{lua_prefix}",
            "--lua-suffix=jit",
            "--lua-version=5.1"]

    system "./configure", *args
    system "make", "build"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Rocks are installed to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks

    A configuration file has been placed at #{HOMEBREW_PREFIX}/etc/luarocks
    which you can use to specify additional dependency paths as desired.
    See: http://luarocks.org/en/Config_file_format
    EOS
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end
