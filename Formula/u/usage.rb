class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6dcc93dff6511f52a44b79e9c9e7192aca2b288c55a7ab00e560fb5800fe4586"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af9b39237380259fb5bbd96e5d58ce11a42400fc80cfa9a85d457f70a66f800a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01f8c6a157a3e4a9d284adbd897c9112aabb4a7b749b53fc193c43d2b8995364"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3f66c58c09d6cb2fccab0be39d680d1a48f13442bd36d3c2e91e521f3729975"
    sha256 cellar: :any_skip_relocation, sonoma:        "26f08ac337ccb25997be51da8ff6ccd44ee7b8b3f4db29b20e6665782845244a"
    sha256 cellar: :any_skip_relocation, ventura:       "1508439dfe58e633f61362be9d49a95b6aefa40b28fea6cad01c5149fd2d786f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d625ce09e384a46f611de4c8fe50077e7578d4894774122100c1a4149aa8699e"
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
