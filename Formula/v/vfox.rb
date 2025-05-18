class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "19755743d88d4ab6d01d431c2c1dcdc7fea005abda9fc8ef067389ae50a30346"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70fe5d5fee78c146181974e46d84081c7243994800d6838db3d98e3a8c0acebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e70ef0db87295e56e4b07b42599cc34c2b690db5c3d041add31d296339041f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "565da4216d9d440763a310f3c6ed93b58a5df87c9d4b9a47693829796c6dd7a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "382e8dda58609d08a91173f507dc55954e6cbc2437eb0e5a6c775a2ab80537c5"
    sha256 cellar: :any_skip_relocation, ventura:       "cd7c8ba4694b9059a108d90096cb5f66eecca308975063fb0c084f1c8711fe0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2fbf1469782266018c291820769c069db43b7c9e0cbd4b31d223672aa370c3"
  end

  depends_on "go" => :build

  # bump purego to build against go 1.24.3, upstream pr ref, https://github.com/version-fox/vfox/pull/468
  patch do
    url "https://github.com/version-fox/vfox/commit/95fafd2b5b5243054c53bf5cb9f6b5b64c5b039a.patch?full_index=1"
    sha256 "05704a0a326ba669311b8b38b1433aff30a91a9db165bae2c681ec7cbc80bd8a"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
