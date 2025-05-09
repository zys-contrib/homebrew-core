class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.9.2.tgz"
  sha256 "680ea4a627427ee7c7e1f7ef7dae55deafe9a717cb941ca1eb03228adc8e02c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd8331f51c25bfd570dd98483c76e84374c9d87e72553be9c24f3630d20709a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd8331f51c25bfd570dd98483c76e84374c9d87e72553be9c24f3630d20709a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edd8331f51c25bfd570dd98483c76e84374c9d87e72553be9c24f3630d20709a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a457135c01ac513047ad7f6621ee19ae3bb8f2d8e84b433574deb8fe97d6be32"
    sha256 cellar: :any_skip_relocation, ventura:       "a457135c01ac513047ad7f6621ee19ae3bb8f2d8e84b433574deb8fe97d6be32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd8331f51c25bfd570dd98483c76e84374c9d87e72553be9c24f3630d20709a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd8331f51c25bfd570dd98483c76e84374c9d87e72553be9c24f3630d20709a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end
