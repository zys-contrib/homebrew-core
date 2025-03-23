class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "0c0e22f2f19cbaae5746f09cd42c9178b338f21314fdc8067fafa163e85cb4de"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a61e35ab3ee4be8e68c6e56029ebc77311030a951de7cca1b6185465e41a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a61e35ab3ee4be8e68c6e56029ebc77311030a951de7cca1b6185465e41a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18a61e35ab3ee4be8e68c6e56029ebc77311030a951de7cca1b6185465e41a0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a90e79eca9c15448a6ba1e6b6d5ac489e16431d3018d4bd34a9f4f87d5ef7300"
    sha256 cellar: :any_skip_relocation, ventura:       "a90e79eca9c15448a6ba1e6b6d5ac489e16431d3018d4bd34a9f4f87d5ef7300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce3b9d2b37b38ebc202648823ed78536f7c64ed8acfff4336651e4398f71e6bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/f2"

    bash_completion.install "scripts/completions/f2.bash" => "f2"
    fish_completion.install "scripts/completions/f2.fish"
    zsh_completion.install "scripts/completions/f2.zsh" => "_f2"
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_path_exists testpath/"test1-foo.bar"
    assert_path_exists testpath/"test2-foo.bar"
    refute_path_exists testpath/"test1-foo.foo"
    refute_path_exists testpath/"test2-foo.foo"
  end
end
