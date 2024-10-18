class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.22.tar.gz"
  sha256 "c40e79dbc0feba5f0d7fdf8b9972316598d292c66ad294d1d57f62daa0524860"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f26514b4b2a1266884dd60a516517cfaecfeccaf99c23cc0696b947b15c69bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f26514b4b2a1266884dd60a516517cfaecfeccaf99c23cc0696b947b15c69bee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f26514b4b2a1266884dd60a516517cfaecfeccaf99c23cc0696b947b15c69bee"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb47ba27a8dd593be8ccefde00c277c1eb4d2b74d0e77d9be653134577984c2"
    sha256 cellar: :any_skip_relocation, ventura:       "feb47ba27a8dd593be8ccefde00c277c1eb4d2b74d0e77d9be653134577984c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310440380a70b3c4015206ca705cd227686344f0d895907ff7d11af6230e571f"
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
