class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.155.0.tgz"
  sha256 "c4d86e0f0407e506a706ab86a17b42e3ec0c7d9f522c78f10de4e4873043bab4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac30b4b310054b0e95c4e40bd6d969f3ba74bf5154f8f09cc43ea82814e81df0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "316d5e6d36440103b12bf484b7ac93001e8b2672b092b52e67f05bba58ec7c63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab109a20fa64c6fb62812ca102525935fac5a6d60b246e70b934ce86864f8065"
    sha256 cellar: :any_skip_relocation, sonoma:        "b73365ce720671e10eac92ac6ccce527dfa6c3a42c3c77c67cc3d83db0db1261"
    sha256 cellar: :any_skip_relocation, ventura:       "85b9a31b145db7437f8f3de3bd04287f292b76a5b8094671ab4fc7c0167959b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d6b22aff1d201579ec5fef1b2103f88a6cc4f276d24f2999db891f0cbfe80f"
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
