class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.4.0.tgz"
  sha256 "79b000d2e84b13b587a28b0a4f913c1dc528fe578b07c9db2530c45cabdc9451"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b4aa973fd51dda060d54b919cdec37c70b99345778dc2e58ecfdffb8e2527d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b4aa973fd51dda060d54b919cdec37c70b99345778dc2e58ecfdffb8e2527d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62b4aa973fd51dda060d54b919cdec37c70b99345778dc2e58ecfdffb8e2527d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed186a7d07b83ae860c9cac38d3cd996f67532172133e47abc96cbb7a4c6165"
    sha256 cellar: :any_skip_relocation, ventura:       "bed186a7d07b83ae860c9cac38d3cd996f67532172133e47abc96cbb7a4c6165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b4aa973fd51dda060d54b919cdec37c70b99345778dc2e58ecfdffb8e2527d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", base_name: cmd, shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
