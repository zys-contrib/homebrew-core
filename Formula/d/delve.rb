class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "1bc657e7e429c4917b6cae562356bf6da6cebcd4fde35f236e8174743d9e1eb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40340281872fe91679ea33a22c4f1388d2400655ae42f0a3c740c3dc011042ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40340281872fe91679ea33a22c4f1388d2400655ae42f0a3c740c3dc011042ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40340281872fe91679ea33a22c4f1388d2400655ae42f0a3c740c3dc011042ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c660327dcfd548d67dbe7bb62c0862fb96e702d703f39075215b0f7266cedf7"
    sha256 cellar: :any_skip_relocation, ventura:       "9c660327dcfd548d67dbe7bb62c0862fb96e702d703f39075215b0f7266cedf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba5dbcf2d6e69c0cd0324bdc83e34e9783ea442508ca577c5abb6e508a7e304d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", "completion")
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
