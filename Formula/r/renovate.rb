class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.6.0.tgz"
  sha256 "adcd265b79c7863f9bd95c6b8f89e1319a0432396b5ac59aa3c1a077fc344a8d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29b70b629ced6ecca36e34849325462e3f53760cdd9cbbaa55415d86bf0a1c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b6ae08d6f61ff330d632de5a2d936aa6a46288e5960ae47e3eab989cdd0d390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "928bf16f548a698f2d8c826739155f7424fc8ef258b30e341407ec8f6a6b8116"
    sha256 cellar: :any_skip_relocation, sonoma:        "083e9379a1b60860b9743bb6d61c87f36ad430fccddbd7e3c8cecd792c686658"
    sha256 cellar: :any_skip_relocation, ventura:       "bff5d70df537c856cfa7a1e3e5fbde419a8dfe00a6d41e4a716b119a1717013f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f161ab79a3b7de174250ee0f02a74a85092dc8a5606d0a12fc2d3cf435ffc1"
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
