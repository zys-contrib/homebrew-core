class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "93be60658c4423845592f60fff63a2cd49ca1d24e0a2883b566864aa9972b489"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb44fa61a4126004ef38d214a889254d26bd95d0e8bc8b30c7c6e0d13c12f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb44fa61a4126004ef38d214a889254d26bd95d0e8bc8b30c7c6e0d13c12f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdb44fa61a4126004ef38d214a889254d26bd95d0e8bc8b30c7c6e0d13c12f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdc0c981f6d90bd5145eabf65988b312800be94519eea60db00f886cfe5f4048"
    sha256 cellar: :any_skip_relocation, ventura:       "fdc0c981f6d90bd5145eabf65988b312800be94519eea60db00f886cfe5f4048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5519e61eb4ff822bcb30b32e6f8bd414b852141340373a9b48fcf47c2d95a6ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
