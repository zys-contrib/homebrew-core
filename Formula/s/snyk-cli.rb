class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1295.3.tgz"
  sha256 "ed8bf57740608412cb3edc65845b96a4745029a1bc577aac019e86acd52327bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50c82fd61bc343bef03cd27f8cb5b7c60b27085a3909cda4108b295dc0b24e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50c82fd61bc343bef03cd27f8cb5b7c60b27085a3909cda4108b295dc0b24e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50c82fd61bc343bef03cd27f8cb5b7c60b27085a3909cda4108b295dc0b24e32"
    sha256 cellar: :any_skip_relocation, sonoma:        "31067e39435d66f67983eaec0b236a7d00df943a866db85354aa798715a207e0"
    sha256 cellar: :any_skip_relocation, ventura:       "31067e39435d66f67983eaec0b236a7d00df943a866db85354aa798715a207e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "229beee13dc8e90673774c9228c4f55ca84c11cd55ac0bddc7f4810a7065e1d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end
