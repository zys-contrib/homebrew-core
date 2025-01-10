class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "4666b1497e5a0fd2efc2926c658dea9b4d8fcdb4abf8e0e3accaf72f4abb8910"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da2757d18369ef200692856e507491a13535dff2944e46b69a674904c0264eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da2757d18369ef200692856e507491a13535dff2944e46b69a674904c0264eb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da2757d18369ef200692856e507491a13535dff2944e46b69a674904c0264eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f65bea7b2b422b572f645653b77123810e5f5eb48eddec3aa6d890a77dec32"
    sha256 cellar: :any_skip_relocation, ventura:       "17f65bea7b2b422b572f645653b77123810e5f5eb48eddec3aa6d890a77dec32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c998c92de1a1d11cf3b8bff57b340ec41724c371e2971847505ce5b3d253b026"
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
