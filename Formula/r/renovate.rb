class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.44.0.tgz"
  sha256 "b7b57f4b40ad7908caff5bd43f5466a32a61839c20bd435e0a70f1e72db931da"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469ad56caf1a717449aa0eef96152483a090dd93bbd807b2838ede2f272b277e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "794fe1cd9118f4d684865584bc9f47c30faa0df3e344ab7e218ea05b6fa68a5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b872295633ae934d8a3b6560a84a570e5e812869286780ebe6b468b14fe6b9df"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5a89b4b2c7bad9bda61b0900a9c24bbb70e8a4a3dfd0ba69348fd884dc04e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "95c6a07b4057f915b840cd4534e6673b4525a6baa231732387a025c876d04004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dabbb2f2e64baeaa3a345f8969586060f049c2178898c99704d05830242b9ba9"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
