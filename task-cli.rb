require 'formula'

class TaskCli < Formula
  homepage 'https://github.com/shutterstock/task'
  # https://github.com/shutterstock/task/commits/gh-pages/build/perl-5.8/task
  url 'https://github.com/shutterstock/task/archive/5b54157e7e2d13bfe0baf350559f5c0bd8433064/gh-pages.zip'
  version '0.0.2-5b54157e7e2d13bfe0baf350559f5c0bd8433064'
  sha1 'bb3b1dce4d2e215d0a8365e2178b80424cdd4cc7'

  def install
    bin.mkpath
    system 'mv', 'build/perl-5.8/task', (bin + 'task')
  end
end
