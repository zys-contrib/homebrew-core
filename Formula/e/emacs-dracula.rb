class EmacsDracula < Formula
  desc "Dark color theme available for a number of editors"
  homepage "https://github.com/dracula/emacs"
  url "https://github.com/dracula/emacs/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "6650e5c83c419878785f555f8a23717b37eb50f897e95eedd9142f4a8d7ed616"
  license "MIT"
  head "https://github.com/dracula/emacs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ed7fbe1661eb170cde9b14570c5b3af6cb83761d50ed5cc65fa3cdaf21bdabb9"
  end

  depends_on "emacs"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    system "emacs", "--batch", "--debug-init", "-l", "#{share}/emacs/site-lisp/emacs-dracula/dracula-theme.el"
  end
end
