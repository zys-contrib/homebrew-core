class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.11.tar.gz"
  sha256 "ef39da4219e34f6d9d189bcff54c82bf67b7b0a28c68a6ec72de91e535bf1640"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4916475d32521f284080963ea362ef48668cb6ae41a1756c2791b92ff512484e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4916475d32521f284080963ea362ef48668cb6ae41a1756c2791b92ff512484e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4916475d32521f284080963ea362ef48668cb6ae41a1756c2791b92ff512484e"
    sha256 cellar: :any_skip_relocation, sonoma:        "37dd3bca85382e4707e77a10b66e4b478684dff0e325497ecf7f76fa00ee5f62"
    sha256 cellar: :any_skip_relocation, ventura:       "37dd3bca85382e4707e77a10b66e4b478684dff0e325497ecf7f76fa00ee5f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a85ab44b54b824ba16be03e8c28d3e7573ec85ddb97c4f2731878aaee85130"
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
