class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.9.tar.gz"
  sha256 "d98b5b93f40ef72facb67c2ec119dfcd5dfc4eb49f7c081ab7a333508bd45e08"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9eaec3601ae1173928fc4b801c736bed7324c616b867db708544b856781fd18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9eaec3601ae1173928fc4b801c736bed7324c616b867db708544b856781fd18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9eaec3601ae1173928fc4b801c736bed7324c616b867db708544b856781fd18"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef21fc5149885f26e378e322fbdb37258185037b61c62dbcda54d1e9c356967e"
    sha256 cellar: :any_skip_relocation, ventura:       "ef21fc5149885f26e378e322fbdb37258185037b61c62dbcda54d1e9c356967e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d0eb32b2810a2b0b8debafcd79757336bd8b8abdd16adf01504a2c06c70ae65"
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
