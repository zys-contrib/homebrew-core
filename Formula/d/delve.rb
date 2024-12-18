class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "940fc50d6338dfe515982ac5fcc3247616f23e2652048ac4f2b439ebd51741c1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f830283f8e3efd8131e88774f925994e007821c553063bbe89cc92b7c19381b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f830283f8e3efd8131e88774f925994e007821c553063bbe89cc92b7c19381b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f830283f8e3efd8131e88774f925994e007821c553063bbe89cc92b7c19381b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3da45578bc1d681644ba862dc74074cb1b38f2c26928e11bab3faaaac5a7575f"
    sha256 cellar: :any_skip_relocation, ventura:       "3da45578bc1d681644ba862dc74074cb1b38f2c26928e11bab3faaaac5a7575f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9c726e7f65f686aded93c0cc59ba2933361be5b7f02b71ca7eb79aa831be88"
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
