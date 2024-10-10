class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.2.0.tgz"
  sha256 "4352fbc3e34b086d5036ad2fa693ad89238157a3b8716562740856afb317ce3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b685a8942c7b11fdffe263f8536914760d84de99776b1aaf9a5b80791e0b96c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b685a8942c7b11fdffe263f8536914760d84de99776b1aaf9a5b80791e0b96c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b685a8942c7b11fdffe263f8536914760d84de99776b1aaf9a5b80791e0b96c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a306bf4fa3ed23b7d860d796729a0755a63f6bf3e1db8c7f618712709f43f77d"
    sha256 cellar: :any_skip_relocation, ventura:       "a306bf4fa3ed23b7d860d796729a0755a63f6bf3e1db8c7f618712709f43f77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b685a8942c7b11fdffe263f8536914760d84de99776b1aaf9a5b80791e0b96c"
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
