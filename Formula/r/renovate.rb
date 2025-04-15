class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.245.0.tgz"
  sha256 "ef0dc657dcc2b34f1a365f7228ffb2bb4e34541488dbd1fa579e905f8ad4a8d2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285c393c4ffe65afe5d7948e743fb4442b4566e541221b18bc6f94106a78f74f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb16b8324bf1bbb11a6d73c42ea0c3cc97d44f0a5eef20b7ef05c2cef763949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75487b32c3bc7b8a49ec282027163824ec86ae238ea5267adc099632415732e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e096f63c10cd92f0590c7e4b4b93308acae02ae3aefdaf977c46beb478e7bea7"
    sha256 cellar: :any_skip_relocation, ventura:       "250069bbba233833ae2801b96b723497579258db70dff77c085b575947bcd586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5eb2620cfe165dc4f61982eb4aec479c86f1f4484a40c53e9666f1d98fa0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0d3a64298b2a7632dc1794c7cb5dcbdb8f94442860b7695e84bf3aecaf2359"
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
