class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.225.0.tgz"
  sha256 "9c07e4d4f7e0e63da29ac7c2f927e82d3e1db9ce2d2f932093739557ed3d22bf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e19e6e548ac3c0fce200f487674d88795fb8d3c23d1a602c43da9a04f9ed07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1768bc6f09411e169f294b202f3f5d4035252d5b7bd3eb64f9f21770ec43230b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63be3ce08360f6fc785e68e005157a5e6a14857e5ec41bf625be4895707717b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9634609a1a4312c4b6da6fe0065a7bcec3a683965fcea6e16bcee2417d465808"
    sha256 cellar: :any_skip_relocation, ventura:       "eff59bd30f0e42a9976b258b482da2b1ff3fbeafdb5a69ef1fdcceb87aa3f24f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c26dac40e033645a8e9cae695cd7892d0158e64f8e7c8a367cbc9b69b91beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bc0aeec06e2fe0dbe671d57aa1bcb60072053b3f6372f62fc86c6a5cdb6434"
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
