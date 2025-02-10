class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.8.0.tgz"
  sha256 "a8b28ed8f6198616b7ec37cf47b99c59ebaf4e3c4037b08c6ddc09e1ed77eda1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1add8017ef22809e3a32a036d8baabd66607f904c4fa0c3b6bcb88551812de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1add8017ef22809e3a32a036d8baabd66607f904c4fa0c3b6bcb88551812de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e1add8017ef22809e3a32a036d8baabd66607f904c4fa0c3b6bcb88551812de"
    sha256 cellar: :any_skip_relocation, sonoma:        "a843e90f2885576be2158d9a8f858415c76ff5e8d859e1fd642465654dbb9c4b"
    sha256 cellar: :any_skip_relocation, ventura:       "a843e90f2885576be2158d9a8f858415c76ff5e8d859e1fd642465654dbb9c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1add8017ef22809e3a32a036d8baabd66607f904c4fa0c3b6bcb88551812de"
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
