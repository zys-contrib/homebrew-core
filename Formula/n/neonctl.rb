class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.12.0.tgz"
  sha256 "6b37019e3b995167115fcde44c3156b5b781b8c51b003f1dbd8adb572edc8976"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef08c1a179d6c63fe5f5ee6eafade7ec0681ea890d5c84f385f8b48ced2106a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef08c1a179d6c63fe5f5ee6eafade7ec0681ea890d5c84f385f8b48ced2106a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef08c1a179d6c63fe5f5ee6eafade7ec0681ea890d5c84f385f8b48ced2106a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e37b965eb3d0992e3e721b2c1e70c61406bac4f30e031235499ee79d9d02f221"
    sha256 cellar: :any_skip_relocation, ventura:       "e37b965eb3d0992e3e721b2c1e70c61406bac4f30e031235499ee79d9d02f221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef08c1a179d6c63fe5f5ee6eafade7ec0681ea890d5c84f385f8b48ced2106a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef08c1a179d6c63fe5f5ee6eafade7ec0681ea890d5c84f385f8b48ced2106a1"
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
