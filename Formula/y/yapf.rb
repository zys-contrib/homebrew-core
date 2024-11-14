class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/23/97/b6f296d1e9cc1ec25c7604178b48532fa5901f721bcf1b8d8148b13e5588/yapf-0.43.0.tar.gz"
  sha256 "00d3aa24bfedff9420b2e0d5d9f5ab6d9d4268e72afbf59bb3fa542781d5218e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311cca4a3125dfedabd1d2ce843fcb82c20cb39985450e5938cf7d2949ac22fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311cca4a3125dfedabd1d2ce843fcb82c20cb39985450e5938cf7d2949ac22fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311cca4a3125dfedabd1d2ce843fcb82c20cb39985450e5938cf7d2949ac22fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a78cb051f1bd38c7a7403f0d290f614282f4fcb75606478f642a405d94bfedf"
    sha256 cellar: :any_skip_relocation, ventura:       "8a78cb051f1bd38c7a7403f0d290f614282f4fcb75606478f642a405d94bfedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78324721748810507339a113338a63874c4174d390b195f869e8238ca216282c"
  end

  depends_on "python@3.13"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
