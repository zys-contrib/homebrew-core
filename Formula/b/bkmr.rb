class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.20.2.tar.gz"
  sha256 "400312d40f8762ee3c10934ef3d456b38760703a493ed7127e9eaec19b9b3c34"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79084c0d480b22d3c7910b666c80f297fd73a55136e31568839dad3804aa30ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a812739e07c4d68fc24b3682eb4bc0e0582d10eaa8e931e6649f560fa4182d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15080316a55fca8676e80a893be4942fe8964f6f3bc2aba35e825a95dbe648d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade0a7d4caad1f8a2c3fa063db92d880225668de22a245987783fd731ae0c179"
    sha256 cellar: :any_skip_relocation, ventura:       "20073c6b60c78ee55935848531fe973edb9350726c23cd6fcdaa8c7838eed961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6d43e29827ab2fbc7b58910f0cdb7ff9698e7d07835e96c0585c9d0d87664c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83747791a250c673d000397ae3bb0bfc71535e9f78685c8a042ce69898ef01e3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
