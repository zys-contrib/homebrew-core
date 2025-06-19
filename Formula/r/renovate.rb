class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.0.0.tgz"
  sha256 "40a30cdef2762c4185c8fbedbba9217385ba0ab4ab2ffa0fee33c4652c67a718"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c28de82b6e999f3bf90f8ae52c39f5fab05d4e9371330ca6b9966dfe75563d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d08d3bc3a713545801b968d5f71669e36ad2e13572e01aec276cb93d3ce5ba36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3a8bdc0dd22f9ae6a4f247199b7bc2d40ad245733526243f3a7d1797314388c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cf50a6b50aac35f10f3bc88d922152e2924b29153af867fc02c32466b326928"
    sha256 cellar: :any_skip_relocation, ventura:       "3c03755cbc89b4318eaeebfaaf7f8411b25b00186aeb3300aaafcfaad2a38d6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e5b962edbcddc852644a72445b271fdd28c0878c277ea181184acebf3f551a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65e5c83f9cc56eed682bdde78821d06abf42005ef6eaff244c62ce098736b65"
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
