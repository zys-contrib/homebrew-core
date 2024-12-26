class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "5dbdd5c68d5872ed7b91c498c3c1824707962a8025c69b735d72d538ed4e8ef1"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b8f4deda0d795aedb6c754445cb40236d330afd732aa6322ceb7623be285a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b8f4deda0d795aedb6c754445cb40236d330afd732aa6322ceb7623be285a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b8f4deda0d795aedb6c754445cb40236d330afd732aa6322ceb7623be285a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b4f3f353c606f00cd59db4926c013a5cb5e7ffb07bcf439b0caf1136481a9b7"
    sha256 cellar: :any_skip_relocation, ventura:       "0b4f3f353c606f00cd59db4926c013a5cb5e7ffb07bcf439b0caf1136481a9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3ae4ef4507e56560ab2ab3ddc088d5cc4f5a0d0b16f022656c64b3d3e257543"
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
