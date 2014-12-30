require 'formula'

class RockRuntimeNode011 < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.11.14/node-v0.11.14.tar.gz'
  sha1 '159860fd6d27c9abf2254529e22fe67e385809d6'

  keg_only 'rock'

  depends_on :python => ['2.6', :build]

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make', 'install'

    (prefix + 'rock.yml').write <<-EOS.undent
      env:
        PATH: "#{bin}:${PATH}"
    EOS

    runtime = var + 'rock/opt/rock/runtime'
    runtime.mkpath
    runtime += 'node011'
    system 'rm', '-fr', runtime if runtime.exist?

    File.symlink(prefix, runtime)
  end
end
