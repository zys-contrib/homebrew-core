class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.7.21.tar.gz"
  sha256 "df4ee9d66d7b6071496ed314c7633dc823b7aa4ed4e1d75278982eae78a0c85f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41104d275eb38150d93d18c25b98851a27dd5f5df45cd1625fd4480b1074069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41104d275eb38150d93d18c25b98851a27dd5f5df45cd1625fd4480b1074069"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f41104d275eb38150d93d18c25b98851a27dd5f5df45cd1625fd4480b1074069"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2dca9445447c601355f94a2bdc713c9f6c05a2687c7fb782fac7f339c453079"
    sha256 cellar: :any_skip_relocation, ventura:       "d2dca9445447c601355f94a2bdc713c9f6c05a2687c7fb782fac7f339c453079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83cb48f03e236c11d25567fdfaa78ac27c27ea7bd245f50ee35cd39b04491b4f"
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
