class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "811b658fd8335a57296d9892f334a76b286b2c8b39cead33e9c0942440f8177b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c098e4400092f1caaffb86ae3f7f946e9d474576ed65f89c5b66c756dfe163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c098e4400092f1caaffb86ae3f7f946e9d474576ed65f89c5b66c756dfe163"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05c098e4400092f1caaffb86ae3f7f946e9d474576ed65f89c5b66c756dfe163"
    sha256 cellar: :any_skip_relocation, sonoma:        "4abb1a7751d6af59ab7cd7b84f25248592a428071f7bc0c2b1e86b7fc58392e7"
    sha256 cellar: :any_skip_relocation, ventura:       "4abb1a7751d6af59ab7cd7b84f25248592a428071f7bc0c2b1e86b7fc58392e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5cb3c45d6f59979af6970eb5fac41d380a6cc2bfdfc5bf3922dbf2b6b58825"
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
