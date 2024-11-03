class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "8da1668efd6c53e0a0eff584fdc49c591fa9684cd07c5c4154114549157f72d1"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3a5bc9b13c9d45e74077e72adca0432b3fe4bc206ff2759b3f4789e63d1102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3a5bc9b13c9d45e74077e72adca0432b3fe4bc206ff2759b3f4789e63d1102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca3a5bc9b13c9d45e74077e72adca0432b3fe4bc206ff2759b3f4789e63d1102"
    sha256 cellar: :any_skip_relocation, sonoma:        "063b9700a2fdd5b1ea1c0ddbbb5c695169c2c0b2ff831a1393648010ca5e3613"
    sha256 cellar: :any_skip_relocation, ventura:       "063b9700a2fdd5b1ea1c0ddbbb5c695169c2c0b2ff831a1393648010ca5e3613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b59b34c04355a04366bd9ca997aaae5f5ab36a283329082ed49b973b7bcb395"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://example.com/",
                 shell_output("#{bin}/muffet https://example.com 2>&1", 1)
  end
end
