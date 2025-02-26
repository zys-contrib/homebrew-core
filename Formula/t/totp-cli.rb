class TotpCli < Formula
  desc "Authy/Google Authenticator like TOTP CLI tool written in Go"
  homepage "https://yitsushi.github.io/totp-cli/"
  url "https://github.com/yitsushi/totp-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "45bae6dbd01cc974c10a5ab9705d6162a8ec21b8a6c26872793d40cd4980c809"
  license "MIT"
  head "https://github.com/yitsushi/totp-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1ba65121e55a917ce6d4c8465a7151036b599623501019c2a4e3fcee8c7690e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ba65121e55a917ce6d4c8465a7151036b599623501019c2a4e3fcee8c7690e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1ba65121e55a917ce6d4c8465a7151036b599623501019c2a4e3fcee8c7690e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f1405aea08f73873c8caa778a9cb0d9d88649cbc40ee48fc112a8327490200"
    sha256 cellar: :any_skip_relocation, ventura:       "f2f1405aea08f73873c8caa778a9cb0d9d88649cbc40ee48fc112a8327490200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8132b854a0f30b2e49ca2d3364e3b7a6aadfa319241d8bb5c9586b505bb121b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "autocomplete/bash_autocomplete" => "totp-cli"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_totp-cli"
  end

  test do
    assert_match "generate", shell_output("#{bin}/totp-cli help")
    assert_match "storage error", pipe_output("#{bin}/totp-cli list 2>&1", "")
  end
end
