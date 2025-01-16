class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.111.0.tgz"
  sha256 "113a7aa490b5cb47dede55ce8c378842f1952383259dc2f3c932c7e35b1be8d5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2c377b85b1dd06b3d6fcc24103f6d8892363d414c4592de172da24270e36a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b41b5276eeb0221fbad4d1c86485ca0f1fe5e1ae600367631d14a0bdf85d472"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "083951b4682138b21088912f1fabf0efc1838a9f340e068f189b73d1e6eeb076"
    sha256 cellar: :any_skip_relocation, sonoma:        "fca6cc3288c2d4783ea4ed616564e32cd98fd516bf8b1ea1458a2a1f5fc81de1"
    sha256 cellar: :any_skip_relocation, ventura:       "f13694897994ee564dd65fe08aef45f2927137fc934db300d90dee58c762a100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e6593a555b03a1f4254625d159b1163a36bffcc13d410b1982a2ff226323bbc"
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
