class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "f573e9b8f08e8b2e26a820dc54f245d3ff9464d3edf3dd9e9b1276401be680aa"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b0f16da65c411b583671d1202720dc5b7d2b94d1c708a984c988d2f9d9a03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b0f16da65c411b583671d1202720dc5b7d2b94d1c708a984c988d2f9d9a03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7b0f16da65c411b583671d1202720dc5b7d2b94d1c708a984c988d2f9d9a03a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfcf1e0c08c04e988f16c6bf229550f55cad2608f96a7505afc811ad0fbe93ab"
    sha256 cellar: :any_skip_relocation, ventura:       "dfcf1e0c08c04e988f16c6bf229550f55cad2608f96a7505afc811ad0fbe93ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caed204a9e8c2ed42e5e116ef65e0edc3aee9e39c60101587c0fb1182c0241e6"
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
