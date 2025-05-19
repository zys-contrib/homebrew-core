class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.17.0.tgz"
  sha256 "ffc44178db4451ecccd6192595bca75c1a8e8d15dbac7db64c1361d7d838d55d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eacb87b3e4305cd74f7df25521ee5aa54559d93d4c8eaca3b9bef7ab1140ddd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01aaf02dab489d319a281ecb6d700b28bb68ee37655e77e0c035bf01bd643755"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00ee4e257f1c1c0219f8699a8331e994a7ac71060e0bed5efa10faa25b980768"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1d3782bdca8d789d18195c9c2b17374df10bc91ee5a07f8e129bf2ccaa1a60a"
    sha256 cellar: :any_skip_relocation, ventura:       "ff4ecb60205e793c561aef3f0569cc2301fe4b6297995b577210272263d7eb3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e4e9f8ad4a2d5ac1087237033776c16a9f5088475b09b38d9cd217959bdf757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001d49f782c6e1835eafbd47d5209dbc7fcaf6f695fd0c06cfecd4332c0c69bd"
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
