class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/b9/76/a2c1293642f9a448f2d012cabf525be69ca5abf4af289bc0935ac1554ee8/scons-4.8.1.tar.gz"
  sha256 "5b641357904d2f56f7bfdbb37e165ab996b6143c948b9df0efc7305f54949daa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2bd233dbcca3ff9f5259f2b525bd3bbd22d0e894d313f70682eeff90601a151"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2bd233dbcca3ff9f5259f2b525bd3bbd22d0e894d313f70682eeff90601a151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2bd233dbcca3ff9f5259f2b525bd3bbd22d0e894d313f70682eeff90601a151"
    sha256 cellar: :any_skip_relocation, sonoma:         "e408435f9da8bdba453bd8ed1bbf6ef3733cd6750142a8d23aabc83e951f3cc5"
    sha256 cellar: :any_skip_relocation, ventura:        "e408435f9da8bdba453bd8ed1bbf6ef3733cd6750142a8d23aabc83e951f3cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "e408435f9da8bdba453bd8ed1bbf6ef3733cd6750142a8d23aabc83e951f3cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730c4f0fdd3340bbb9a7e83fffc60618002ed71cc2f0a0901e17923a18766528"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
