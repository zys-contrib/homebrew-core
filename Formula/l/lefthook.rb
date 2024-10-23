class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "fcd86e83863e6decd60a60d19020d321565f60ac5b147afcb9f7361cf771c4ed"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1d0763f7eef0820e1b3045c801d97504651743b17bbb8369024377319be4da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d0763f7eef0820e1b3045c801d97504651743b17bbb8369024377319be4da8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1d0763f7eef0820e1b3045c801d97504651743b17bbb8369024377319be4da8"
    sha256 cellar: :any_skip_relocation, sonoma:        "213b93d854f3f0e787e2e6911c009713ca358cd847583d4c1a50e0c8544c5c73"
    sha256 cellar: :any_skip_relocation, ventura:       "213b93d854f3f0e787e2e6911c009713ca358cd847583d4c1a50e0c8544c5c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c93672c245e6d5ba2fdc7fa457efc83f58a77856ba9227b836a517ad3e11226f"
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
