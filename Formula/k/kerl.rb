class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/refs/tags/4.3.0.tar.gz"
  sha256 "3270070f4a61a080508810a9fea2a3173439cc5dcaf12ea69ca8baf0d68aadd9"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68b0f3b236587140f018793ba4ed38114e3a3241b326e3afe98ef174a8471372"
  end

  def install
    bin.install "kerl"

    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system bin/"kerl", "list", "releases"
  end
end
