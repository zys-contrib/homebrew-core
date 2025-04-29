class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "8bb83882697af81d950a27ad4edfa4b11c93c9982e02d34589a656ca15b58169"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a84f0ad53abcfa702830ff9b17832ed9c0b0672a0eb1f655d167fad6290f320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8318b20256fb8e72a0669b80fc9fc3718817217cf6f26bff2790c9488302236e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13960b5e05b182bd725e156d74c2e193e400297685d306c42685be3ba1b8300f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8f6b6a83795e54d3e2f99bd0ea7d9aa5b913901dfc0bb09a3aa718ddf23a83a"
    sha256 cellar: :any_skip_relocation, ventura:       "eea3acf65908a3dd6196e8f91e2233f82a9861e5dba7efbe53eef64f284dea7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0b745305e733772f8052d65b9866202945f9e736ccad052f695b6e56fc88b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1443bb536fe063999f666d1564075cc7c73f4e05fb5859905faee44f3f8ae3e2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
