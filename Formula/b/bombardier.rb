class Bombardier < Formula
  desc "Cross-platform HTTP benchmarking tool"
  homepage "https://github.com/codesenberg/bombardier"
  url "https://github.com/codesenberg/bombardier/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ecab7b58a5f7fbb74ca390e3256522243087a7ad41f167eead8a62b4c19c12a8"
  license "MIT"
  head "https://github.com/codesenberg/bombardier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1d958586d41468d4cbd0be867d113fd7a92da3acf20abee3610825f2dc04eb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d958586d41468d4cbd0be867d113fd7a92da3acf20abee3610825f2dc04eb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1d958586d41468d4cbd0be867d113fd7a92da3acf20abee3610825f2dc04eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9af36eb04d67a945da3416439d7b73106904de2df9bbb3924b52392b4a3e4bff"
    sha256 cellar: :any_skip_relocation, ventura:       "9af36eb04d67a945da3416439d7b73106904de2df9bbb3924b52392b4a3e4bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848602f067f4491a724dca02bd7972a38035aaa08ff811a92f0d08f115a6cfc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bombardier --version 2>&1")

    url = "https://example.com"
    output = shell_output("#{bin}/bombardier -c 1 -n 1 #{url}")
    assert_match "Bombarding #{url} with 1 request(s) using 1 connection(s)", output
  end
end
