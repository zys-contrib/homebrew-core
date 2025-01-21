class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.119.0.tgz"
  sha256 "930b25787a53da2147958c9a664b8471ce681b3038e5428bf571a7e09c5f242f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117ce77ba7b8a3f5369c6b8302589e42970d613363a1945f4279196fdc4d9b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e4a984a8ca071d7fde11850972092b74d16f9fb9ad50b2671feb60c416e5ace"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "809b71f6e8f4dc7559279f7a481ff7fe4371f28eb27d3174fabf3bd8da43ebaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb485207548c4ffbb3119051c979cd3e23a3a0346b228ec5a65b906bd630e92"
    sha256 cellar: :any_skip_relocation, ventura:       "78cdf698b18d6eed0963347fd44f767b98a9a0d645f5009dbcc81100840759dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "182d672f6dc3e59b38e095d56690064d1055bcbcbf89b0f0d13c19b0b4ee555b"
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
