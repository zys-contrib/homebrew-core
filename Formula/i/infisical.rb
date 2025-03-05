class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.36.8.tar.gz"
  sha256 "928ba9b5f61f9fefe0f8f8abc5e4144536fa6da6b004f164bbe95cc4908b5447"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37aeb30e56eec6ed8e666ae40269dfc10ed363af8e4afcb9d4efc3b008bacc35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37aeb30e56eec6ed8e666ae40269dfc10ed363af8e4afcb9d4efc3b008bacc35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37aeb30e56eec6ed8e666ae40269dfc10ed363af8e4afcb9d4efc3b008bacc35"
    sha256 cellar: :any_skip_relocation, sonoma:        "056554712839b77fea686bf6a2808239010c6d6dde06b88e62463894d8d971a3"
    sha256 cellar: :any_skip_relocation, ventura:       "056554712839b77fea686bf6a2808239010c6d6dde06b88e62463894d8d971a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b3298c7b32a7373d4544b83479f3e2ec7efb39f5f3d9de4e25ed8e12f63f077"
  end

  depends_on "go"

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
