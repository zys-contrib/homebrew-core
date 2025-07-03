class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.15.tar.gz"
  sha256 "3d38498e914eeecf9c4164e1ed17f016ef2a78ce1c05fbccdf39b31e28a0c4dc"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9de18d278350538782b4f27c82b692bad406b198c4ef71e86afcd40e86aae980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9de18d278350538782b4f27c82b692bad406b198c4ef71e86afcd40e86aae980"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9de18d278350538782b4f27c82b692bad406b198c4ef71e86afcd40e86aae980"
    sha256 cellar: :any_skip_relocation, sonoma:        "45de4c84da713d331dc1cd5faf936aa29b35e802c65e7d4b96bf5aad359da5bb"
    sha256 cellar: :any_skip_relocation, ventura:       "45de4c84da713d331dc1cd5faf936aa29b35e802c65e7d4b96bf5aad359da5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2598a9905f92e9f73a37f1fe6e77fde222bf6ee0c1f1503d1f9d950c343e764c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
