class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.14.tgz"
  sha256 "cd98ffe341f620e2f5317b85fb1d7374bbc8c9ec11709505ba01c02346aa23f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6986cb2ac1c0fefbfacc45ce0c11d6779c6b5259ad6cbef9690f30b5656264c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38409ea380d13f64f2637fd0021cdb6f83357845ff1ca44b3be667c5e5679b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38409ea380d13f64f2637fd0021cdb6f83357845ff1ca44b3be667c5e5679b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38409ea380d13f64f2637fd0021cdb6f83357845ff1ca44b3be667c5e5679b6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9f0117d66cda22c0700146663700a596082935ff6c36758c0a837a668e57452"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f0117d66cda22c0700146663700a596082935ff6c36758c0a837a668e57452"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f0117d66cda22c0700146663700a596082935ff6c36758c0a837a668e57452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1135e8d730b8d7824b1a7032e63d17bd18357b2b8f632b9af94fb923e8107750"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
