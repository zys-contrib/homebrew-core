class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "e1adb164fa4615134e21b151a9aa8aac5e89a65c6a5868e0e40aba582d64ca48"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0985969601b84bb2f71a388c2099ee5b13a6f84ecb547f9c1b72ec359ec8596d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0acc7b281a8c51f4032acd236592db4818c5a04d2f8b6a2fb765c9f4f0ac35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca927729d97a8d0f76f124bfc82f00b3f8566ca375389a86a96eb05ae2c719d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "866ab5588c5eff820e84f0a427719f44ace574c9da0736ca7f2d16400dbc6791"
    sha256 cellar: :any_skip_relocation, ventura:        "b588f828c3575e998d9446c82cd582e1f406382f206f7fcb5e4efe716eb6393f"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ead2835078a201909f44e3992c87bf0109327d51956caa8b80097bae4907b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb0f7aeebc48260a96e0bcd3127884b9704c917200e76ec7993be27b020f314f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
