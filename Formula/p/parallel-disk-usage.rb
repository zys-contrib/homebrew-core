class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.13.1.tar.gz"
  sha256 "9f22e20764a434b3cb39a8f92b7e11bea851cca99077e15de165a8a25342cde6"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e17a8fff7e894998250e1bedeacd2a3b7a6254ab2bc36418267191b4d9633d2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3bd23a3013d6c254b883098b0d9c77a692fabb063955086f8843170aff713ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "155ddbddee3f23e3acf1a5794c4a57b00b1108e3039d5e450e0736ff6f52d58e"
    sha256 cellar: :any_skip_relocation, sonoma:        "de0bdf4751b6d7db30273c58371e06022aa13c2d222bc0e93a5fae2e4e655331"
    sha256 cellar: :any_skip_relocation, ventura:       "eae9b27b7b4a8306e8a3cb4b523351386996efd730a7b071356f1113b5751aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f8c72a5b073d02ea494d5ea19b4541c39cf66f5cf4b3e5b2e8bd278f6140dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0794dbfb5e47cc8f1e626432f5ca5822cab6f4f15179e2ff1c460a936713939b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli,cli-completions", *std_cargo_args

    system bin/"pdu-completions", "--name", "pdu", "--shell", "bash", "--output", "pdu.bash"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "fish", "--output", "pdu.fish"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "zsh", "--output", "_pdu"
    bash_completion.install "pdu.bash" => "pdu"
    fish_completion.install "pdu.fish"
    zsh_completion.install "_pdu"

    rm bin/"pdu-completions"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end
