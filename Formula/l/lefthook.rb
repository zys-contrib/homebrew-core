class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "427dd33e5913278b4802e64342831f725bd5255a55b6b126d423d38caaa0763b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb15d32c59d41d0e2f7613b0ec545a42ff2f7596e721c8d62d5319600dac7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb15d32c59d41d0e2f7613b0ec545a42ff2f7596e721c8d62d5319600dac7c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afb15d32c59d41d0e2f7613b0ec545a42ff2f7596e721c8d62d5319600dac7c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af03b1846d7ab0621f0d84f4cc26766a81b58056325ed14efce9133d0028a1d"
    sha256 cellar: :any_skip_relocation, ventura:       "6af03b1846d7ab0621f0d84f4cc26766a81b58056325ed14efce9133d0028a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f8caa7607f70c8e90a7c52015ae4a4e5eadbe43d1a63ea4e2d287ca6b48d5c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
