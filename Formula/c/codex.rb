class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://github.com/openai/codex/archive/refs/tags/rust-v0.2.0.tar.gz"
  sha256 "aa59d6af465d1fe89a82ae684ae3d8d5e6c1f6fbc270cc389c5966c6e969d867"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d121f1f81e90c950fdc5b8b9bba62ab1c3445fd7ee5d06882e39e799535a16"
    sha256 cellar: :any_skip_relocation, ventura:       "16d121f1f81e90c950fdc5b8b9bba62ab1c3445fd7ee5d06882e39e799535a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754cf31c59ec4bffde64e85e00a5e4de09400cb29aac35bf86003922e764b987"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end
