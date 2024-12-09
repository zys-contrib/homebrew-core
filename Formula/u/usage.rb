class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7c1db09dc06ef4d54d4defa24c22a06ca973ffb46097629485814c14e717838b"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fa0941616b4b7433ea9285cfe124c2639a924124906b80a60ffdafbf8a758d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1091afe7cfdb35c2472d252cc52a2b695641af907fa3bee8eeb565f154aa5397"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b90e364f6de5b9d6deb0597de5627f1e2bf78a1a47470692cd0681c347f137c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "feff5f4e506c9aaa2f90389fef2b5533615e39a8ec432db797cf3729d0dab301"
    sha256 cellar: :any_skip_relocation, ventura:       "7f001bccc001499fc813e7d7e38d0eb66051295672c0dd2253207790d8e3f3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc5e1e7b863945c18500168ed5e242e74ea4763590b4c9af5c20ae10fd2ca957"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
