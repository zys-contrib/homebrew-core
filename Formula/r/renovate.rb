class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.140.0.tgz"
  sha256 "d496c5e31fd8f513f72ac2c8e6359b9f1c7ff7b8cdc21e8237d59d6bcda2d97a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b3e061334c1d6d7fc865cc3f8eee746ceb5e7a514b968108d7df8c24beb330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a77ac1c64ff40de7ba0cf7404c59a29c8b7503611d2285f1eb822eae8bd74580"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc15d57ba0b87124b11ca4495eb812e82a4a0c6c7b59ba38c19e208aaa14920d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0393f983152953853926f0d87a940d58aa44460c31ea7202fdff8f75b3a0b64"
    sha256 cellar: :any_skip_relocation, ventura:       "9c104ab559acb37b2974f9784d4400eab9312b645b4e3964717793e130d61e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f7a2e783a88397ec590a4c8653e3d0d79a0887cbf57280adccd7ae6086bdc5"
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
