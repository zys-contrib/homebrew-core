class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.37.0.tgz"
  sha256 "c441283fb7c32f6f65074902e747925ca465a108afaa50e1a67ccea499132b10"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "782dcef68dec3ee368bf6ecf6e0f744a90451754d4fe58cec4ce7a33d14a2dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b492d2dd0a287c53ce83fb936c767c30cafbde2838988822bfdb5ae69ccc89d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "975ca977b3b7769abe342e4550f1b01d580a91b7fd8546e537ec66b6c0d4d456"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f184ef2de3945b1c223c37ccb0b59750e488caa1cc322822ebb1f1cbd6646fd"
    sha256 cellar: :any_skip_relocation, ventura:        "c047f1fca263f09788896abbc2be008a035b1fd6c60cac9ff74fd776f4689242"
    sha256 cellar: :any_skip_relocation, monterey:       "351d9a4b70f0f870e02e76c1d6c327f9c547862880352327bbef85f48bf27e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf35496dcc552436e39bc1cae1aef9230792485ee9c14183b5b069524bd6fb5a"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
