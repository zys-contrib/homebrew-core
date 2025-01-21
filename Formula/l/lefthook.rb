class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.10.tar.gz"
  sha256 "01739e087ad698b6a18d7675deb67446b9f50bce000eeb3f1df1a6960d2cb42c"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec7cc8323972d37e3eb72993aa0d49102cd8f958b303470e77e70bdbdbc153af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7cc8323972d37e3eb72993aa0d49102cd8f958b303470e77e70bdbdbc153af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec7cc8323972d37e3eb72993aa0d49102cd8f958b303470e77e70bdbdbc153af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e417fed0792c4c36c35fe292e653f2d18addbf455b8ab66a1f6bd32d0611d189"
    sha256 cellar: :any_skip_relocation, ventura:       "e417fed0792c4c36c35fe292e653f2d18addbf455b8ab66a1f6bd32d0611d189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb9be4471ed437b2da7cf986ba0159e5df6fd0c915e4c7067798bab5a80ae0d"
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
