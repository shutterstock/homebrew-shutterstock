require 'formula'

class TaskCli < Formula
  homepage 'https://github.com/shutterstock/task'
  # https://github.com/shutterstock/task/commits/gh-pages/build/perl-5.8/task
  url 'https://github.com/shutterstock/task/archive/58f5740bd796e521131ce7bcef28fb90ac0128e0/gh-pages.zip'
  version '0.0.3-58f5740bd796e521131ce7bcef28fb90ac0128e0'
  sha1 'df70857903bb46750bbaab512d08f80a587c04f2'

  def install
    bin.mkpath
    system 'mv', 'build/perl-5.8/task', (bin + 'task')
  end
end
