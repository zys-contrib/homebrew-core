class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.6.4.tar.gz"
  sha256 "4c67ea109a56a80c345cc144f16f97c1c56d457fd7b3dedb75adc1b8655ae36d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36df859b5ac5efe1e0be09ffb901da349c3521f107365a994d0357f37e32e15c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0077e70ddc8a5d9b670b2aeaebadd29c2b0ff9eacb03f2dd6392bffb640184ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbba55e6607511a1513409728a6c82f2d41a913a4f492fe6d8413d1014798cf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "47598c62b6e9177181def9c5502ee4a8530dd51bee16b1070981ddf3a2d667c9"
    sha256 cellar: :any_skip_relocation, ventura:        "c54606e90085a983bb1ba3c13c5a4a132c82fbcbbef7a81125134d6118a10d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ca0c3b725c0d9fb3233b2ba81aa36b1ac760f47488cf17e89b69414f75254b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd8bcc1bd866a4f756ccacc3098743045220259f6127ff68a4f1471d582981a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
