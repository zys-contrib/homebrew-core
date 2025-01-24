class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.132.0.tgz"
  sha256 "5da9599fadcc080a9e6ad7fcc5642f47ff21b0156b2ed4d3ef955d0a626c9ac1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7e63696c5f046c7c00902749f626344cff57467b669a020a1a92ef71fa6887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba4e6b8334f31bff121f8de73f581aaa6bfae27650219b2b54d38e7c1bb1248"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "113fe359ebfac670e5bffc386313999ef1cbd92353ccbf4152fb86dfb07e5d27"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b39d0eaca3f5c7285b91d01439874467be9154916cd5ed5a7799f8c8b1ce5e0"
    sha256 cellar: :any_skip_relocation, ventura:       "1a0bb03e7aaef6e482fcce1424df509ce1033790fe857ef813856984d7d8159d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97a4735abe3ed470c4ccd6020078e372555339640d3d748f686751a742294ae4"
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
