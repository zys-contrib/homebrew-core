class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.103.0.tgz"
  sha256 "51a63f45a8d1a1decac9c7c946519cad6c6b0ba3f47b8b2a2962cd3e7c24f33e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30edc43493431953042468ba0938f70f2a4e53c9c21c36e5ce6195d5072858bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5141073ab1ec6c04628498be0418a0fe5e7da5c2364b06c6f7f32468e59517f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cb55573c05d47ebc260ef2faa777375600df19d735db4674938f5d4aea9c745"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aa98c5145278424dd0bbda4858957e374df3edca6968c6d351cb9a56dfd057e"
    sha256 cellar: :any_skip_relocation, ventura:       "b59d1b64698c96820295032df24ea0b5a19aea3a50d9d565e6aaf7bfee00642e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4a127b13626cc2ab2abb099c19cf1ea7214bcfe07b0975ab7110c6fecd3c81"
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
