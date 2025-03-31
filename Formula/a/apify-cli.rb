class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.3.tgz"
  sha256 "1c8a3e93c8ada0985f612ef173742b5a524c792fbc563e1c8179c3abd9b55096"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89b16e4443929bcafb2c9479d10a6de26d9c0e823b963f348fa336fd45e1d303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b16e4443929bcafb2c9479d10a6de26d9c0e823b963f348fa336fd45e1d303"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b16e4443929bcafb2c9479d10a6de26d9c0e823b963f348fa336fd45e1d303"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1bdd007a01d2a2d2d19e58e287b2378bd855a76a5c17bf36374bf8b0c3329bf"
    sha256 cellar: :any_skip_relocation, ventura:       "f1bdd007a01d2a2d2d19e58e287b2378bd855a76a5c17bf36374bf8b0c3329bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ecd1d22553f0921e7b270ef3e018a555163d4fba8937a9267199867668155fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d2a680762fbb4c90fac1ee02e07fdccb09c046a3b141b81daec93bd0d8bf1a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
