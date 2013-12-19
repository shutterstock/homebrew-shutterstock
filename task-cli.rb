require 'formula'

class TaskCli < Formula
  homepage 'https://github.com/shutterstock/task'
  url 'https://github.com/shutterstock/task/archive/a107481266cc567314377b248e145434f5b694bb/gh-pages.zip'
  version '0.0.1-a107481266cc567314377b248e145434f5b694bb'
  sha1 '51520165b12cdd6d9ee391740ba0e3311dde6450'

  def install
    bin.mkpath
    system 'mv', 'build/perl-5.8/task', (bin + 'task')
  end
end
