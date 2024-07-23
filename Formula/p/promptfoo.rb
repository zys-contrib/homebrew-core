require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.2.tgz"
  sha256 "dfa45182dafbc7b78d80a3f151d68d8b7000a24b6c41a0f7c28b183c12f94b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fbb95d800c5106e99576fd21d680ee3d79397eb9bdb6c7cc806a9a8e67dd70b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45328c7d73fcc4f3438819216d6abacb48b82875f371234318e2882e3a859ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ab24b2c1849963fe0e73e258ff5da58ef40fa9c24b1ebdb883436e3a3eebd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf307bbb95d1a40273c459c925809c83b55d4b33037f0d2817905ef3fef33a04"
    sha256 cellar: :any_skip_relocation, ventura:        "2dcc25108107a6a7f52b2a546f2b5ff4c7e9c63d4bc5b1698783c215a9206308"
    sha256 cellar: :any_skip_relocation, monterey:       "0f7ef6e557befc806227233091ec2b3ab11cb8778015e6b9d6b5157cc412948e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb068895e1cd392d789cda97648423270dd28b136481f6cbc6e9500c76416a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
