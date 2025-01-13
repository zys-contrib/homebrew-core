class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "89e33e55ba88285a9f8083d12910dcc1144ec06d7c58f51f3f7c53cbc6bb11ad"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a129411d57efb23cd8e5b60346ef63c85f2b78d00a47fdc85f444b32dfcc7d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a129411d57efb23cd8e5b60346ef63c85f2b78d00a47fdc85f444b32dfcc7d2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a129411d57efb23cd8e5b60346ef63c85f2b78d00a47fdc85f444b32dfcc7d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3da8c54c82be036be9086932d1f22029a2cac001d72d29301168abaf6b74f4b"
    sha256 cellar: :any_skip_relocation, ventura:       "d3da8c54c82be036be9086932d1f22029a2cac001d72d29301168abaf6b74f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c1a1c9a52fb91f2a3afa8ba75e5ca5ce457c59db488387ec14389c466befa9"
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
