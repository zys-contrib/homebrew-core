class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.24.0.tgz"
  sha256 "003c6ad691e4b30b26543c1815a40e32a08ebbdd686b3d6f09c0dea2e35f86f5"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4775a11b7be1f848ec8743a97f308d19007d26ca364eb9ae5fa4e718e480b7a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6bd628079d0bc03e7d07bd62d135d00b45499d6079677e6e3e43757ff346d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59bfc4677dfbd81d4761842ff43f036b0cad85ac2c077efd427aa36e591873a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "51074201174be4151cfb3cf77fe5038e99c8c0e40af925720221f716e6096af1"
    sha256 cellar: :any_skip_relocation, ventura:       "27dcd56b6c6568bfa440e7fdf23a043f933c90ae189c8e3c6874ed62c6e5d5f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f5f65aef44d90c3e0230fb88949b36f3f3c7c54361130a751f1da4ced05a3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fd0de3cf7607913ffc6f3fccd15024a3a7d3acfee8e61f4d66bd91cacecf16"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
