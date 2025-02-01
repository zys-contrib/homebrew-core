class XcodeBuildServer < Formula
  include Language::Python::Shebang

  desc "Build server protocol implementation for integrating Xcode with sourcekit-lsp"
  homepage "https://github.com/SolaWing/xcode-build-server"
  url "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dc2a7019e00ff0d2b0d8c2761900395b39fb69543b9278285d2e85bd57382531"
  license "MIT"
  head "https://github.com/SolaWing/xcode-build-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fccb7dc23c0cffc541fceaf0583e7d305e35551a340315cd067a7cb0723a07d3"
  end

  depends_on "gzip"
  depends_on :macos

  uses_from_macos "python"

  def install
    libexec.install Dir["*"]

    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"xcode-build-server"
    bin.install_symlink libexec/"xcode-build-server"
  end

  test do
    system bin/"xcode-build-server", "--help"
  end
end
