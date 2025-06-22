class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "5bc6836e033ae63187b17e523e808cfd8bb6525715163fdc158bf85f36a2b834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab5bbc8ef07c3f43a68179a3cd262fafd5343bd0aa65ff9cae8156551a85f080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab5bbc8ef07c3f43a68179a3cd262fafd5343bd0aa65ff9cae8156551a85f080"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab5bbc8ef07c3f43a68179a3cd262fafd5343bd0aa65ff9cae8156551a85f080"
    sha256 cellar: :any_skip_relocation, sonoma:        "27b519e5514e47309bce8a346a7c03102441ddacd4c4963ea68f1cc4cda08733"
    sha256 cellar: :any_skip_relocation, ventura:       "27b519e5514e47309bce8a346a7c03102441ddacd4c4963ea68f1cc4cda08733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98190d8631eff7b04f343ef9030aebb1241ba0eed74061d299eaa3d8ec15bb62"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
