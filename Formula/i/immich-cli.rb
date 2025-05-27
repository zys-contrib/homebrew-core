class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.2.68.tgz"
  sha256 "b2597123269ed6425022a4029d37d5acfd8e32870ef2d299ddaa7ca280a3de94"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f97c3a7789393d954b6ac8b5cbde6cf8b574e660d383368fbc11c402acdba22a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output(bin/"immich --version")
    assert_match "No auth file exists. Please login first.", shell_output(bin/"immich server-info", 1)
  end
end
