class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.1.8.2.tar.gz"
  sha256 "bc2a6f6c83c751f6ad4f7d9f25ea24bc0fc269ac765f8e96ce5b89be2ef0d120"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f2903a7bb3f52979ab4ac9780e5d6ec76607bc71b7fbc981e3d784f52e0baa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce5fdd601a103b6aa219b1d441aff9a9b0b535760ae70f066d615e0c86d7ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba73897e54c00309f3a1cc6d1787709805475c1304f6641e6499093eb2200d07"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1e53e4084a525e46abb477b8a2320926750127f40c1e1f118dde9918d611672"
    sha256 cellar: :any_skip_relocation, ventura:        "755ffc6880ee43da9afbfb04e837193eac028e27cc694e690e6fe2f695ba130a"
    sha256 cellar: :any_skip_relocation, monterey:       "0745b821775954ed292e89da9f5a83aa662f48515efcb73277dd7d3e02f2b28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d557ab6b92d0b82730b4c43e89844ad947b0ed9cb38321ebe945632b33bc42c6"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(/mirrorz\s*MirrorZ.*MirrorZ/, shell_output("#{bin}/chsrc list"))
    assert_match version.to_s, shell_output("#{bin}/chsrc --version")
  end
end
