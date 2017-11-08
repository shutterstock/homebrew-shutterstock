require 'formula'

class Vsql < Formula
  homepage 'https://my.vertica.com'
  url 'https://s3.amazonaws.com/myverticablog/vertica-client-6.1.0-0.mac.tar.gz'
  sha1 'b1c758e51d167f17d50a10bac2273eeb056f56c3'

  def install
    bin.install 'vertica/bin/vsql'
    lib.install Dir['vertica/lib/*']
  end

  test do
    system "#{bin}/vsql"
  end
end
