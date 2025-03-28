class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "1de07f9378debf7f1b11c60c424d72af06c461472ae52b03ca820584f7a72b88"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c290c59ccf5512ef1dbbc1b56ef970ef4b71088bc9e65d54355bdc35dcc6a2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f3265ca13ad698ca997ed9bdcaac496e44bd323ca463712e68263c8eac79a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3f21f091074a7a34de008a8a23d5d812bc7318aed3543b8bf95226fad6a9fc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4488c8fb34b5d932c01fc7dcf6711f2b1995cb4436f60caac023d81af2395b"
    sha256 cellar: :any_skip_relocation, ventura:       "16005e5a194fc1d86b49b0a5b7cf68a5b58fc3e746b7cb9f2b5bb1d9b0f2c8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79c5fb99c70b245cd759899272cc3716d40a1655493fd251bf9c6ca08ad0041"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
