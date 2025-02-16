class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.25.tar.gz"
  sha256 "1f994953aa4e9d6718dd7629957db9ee82f766e22975808cded1dcaf722734d8"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c56f4c91cec0dd2847d79ea2ea2bb6058f5074b071251dd319334c6cdcbffea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56f4c91cec0dd2847d79ea2ea2bb6058f5074b071251dd319334c6cdcbffea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c56f4c91cec0dd2847d79ea2ea2bb6058f5074b071251dd319334c6cdcbffea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a46299d7984157151643e57b0add53bcbf851047bff8356f7751e0400dab24d5"
    sha256 cellar: :any_skip_relocation, ventura:       "a46299d7984157151643e57b0add53bcbf851047bff8356f7751e0400dab24d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f54a5b2684df99cb051007a25888871134cbb54bca6c0b07c7248ab175823c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system bin/"wgcf", "trace"
  end
end
