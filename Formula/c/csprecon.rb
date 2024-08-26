class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "886c7628e63e57c93ca1e85b7bd499f629d43e744d91ec1c79e999fa2ec13f13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0a0ccd3e31c6ede553a581586f2c7ccf4b9dd84fd93542ce07a3ce30eab4475"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0a0ccd3e31c6ede553a581586f2c7ccf4b9dd84fd93542ce07a3ce30eab4475"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a0ccd3e31c6ede553a581586f2c7ccf4b9dd84fd93542ce07a3ce30eab4475"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d1f3f5a0ac002b0a0a98d4e7b6a2cb77068857ca35f7a6306df9974046d1091"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1f3f5a0ac002b0a0a98d4e7b6a2cb77068857ca35f7a6306df9974046d1091"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1f3f5a0ac002b0a0a98d4e7b6a2cb77068857ca35f7a6306df9974046d1091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1b45164e77476c003553bb6af51eb0b5a6c3af1b4a943f18d4c5a01968b5bc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
