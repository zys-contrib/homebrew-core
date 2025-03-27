class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c8/c1/30176c76c1ef723fab62e5cdb15d3c972427a146cb6f868748613d7b25af/scons-4.9.1.tar.gz"
  sha256 "bacac880ba2e86d6a156c116e2f8f2bfa82b257046f3ac2666c85c53c615c338"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e4aac6930d155026974edde3bf8a1d4784794d55afc7d6715efdad9fb8a407"
    sha256 cellar: :any_skip_relocation, ventura:       "c4e4aac6930d155026974edde3bf8a1d4784794d55afc7d6715efdad9fb8a407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "469d4d9ed388432e0fa083001925d30aa16975e9a1f138234deb556418cb7b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151c811ed2fb8f49ded747f540963eeb0c9e0709791e4f19de0fe3fef97dc88a"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    C
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
