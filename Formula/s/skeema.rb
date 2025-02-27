class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "a29c42436967b61e6a5b1475b0166e38583c7f0f6381412409d76eaba9cced7b"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb160fe3fad08c9db6ddeb3917ecdf3b2d848f52146686d4e4974b33686646e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb160fe3fad08c9db6ddeb3917ecdf3b2d848f52146686d4e4974b33686646e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdb160fe3fad08c9db6ddeb3917ecdf3b2d848f52146686d4e4974b33686646e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b6ec1f57360bc527113b5eb0000e740d9503d07ff24f60c8dff9a620d56b63d"
    sha256 cellar: :any_skip_relocation, ventura:       "0b6ec1f57360bc527113b5eb0000e740d9503d07ff24f60c8dff9a620d56b63d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2afdfb6a37c9e717ae7c483c29b05a93329fdd75d850903d5ab7b07646123fa9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
