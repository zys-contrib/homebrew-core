class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://github.com/render-oss/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "62d2b561c501646f89045a26d6a9a7d9444457bc725ac0cb1ca9ec204cf334c1"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "989266d826f6ec5c24297cc06d72d2ea9df4a302b2ba2e3e9f4b8d87ec20da82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "989266d826f6ec5c24297cc06d72d2ea9df4a302b2ba2e3e9f4b8d87ec20da82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "989266d826f6ec5c24297cc06d72d2ea9df4a302b2ba2e3e9f4b8d87ec20da82"
    sha256 cellar: :any_skip_relocation, sonoma:        "6678f2653f8a3704084dae3909135b55ca0e74071bdcc3b22528a1388ea160d6"
    sha256 cellar: :any_skip_relocation, ventura:       "6678f2653f8a3704084dae3909135b55ca0e74071bdcc3b22528a1388ea160d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f13c0765d3b920586ca77f1ae82e1d9084653bdd4039209c20935168f920c7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/renderinc/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
