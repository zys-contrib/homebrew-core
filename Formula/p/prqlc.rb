class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.3.tar.gz"
  sha256 "f64c22933ba0d4f5664bacbd2278de41baf74cef3a20e86b718dbd6348fc369f"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9233066bb8690613d46ff4337c28489d17d26eef557e540605f4edf073d8494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612382df672c86e91ab3bfd905175ac04898edf6f90110b5e69b97499305b107"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "797d0ecad3c02117082e1392d8febe2f3816a0d3a52b1f82fcc53b52c84735b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d16beb8b2d71ee21bb79fe2a9012f59d355d11dd8dabce3b5d38509ff23a427d"
    sha256 cellar: :any_skip_relocation, ventura:       "6962e491915d83e04e2baffd143ec649977aa179b9373c817b060189b5738a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a97686a8660a15460858df5725cf1b12a24b01f7f39c3e4a5ed075011e8fa1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
