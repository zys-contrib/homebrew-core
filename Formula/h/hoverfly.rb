class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.10.9.tar.gz"
  sha256 "e03bb5d2182ad2f724d7d2426ae0edcbac5e3ce5fc14d054c2dee0ec41007957"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5ee69a29491fe9c2f44100ab74919e5ee9f45308dfc937e8461f08f1312075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5ee69a29491fe9c2f44100ab74919e5ee9f45308dfc937e8461f08f1312075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af5ee69a29491fe9c2f44100ab74919e5ee9f45308dfc937e8461f08f1312075"
    sha256 cellar: :any_skip_relocation, sonoma:        "96079d6d3345b1baf0a22e27de801802d9e2209b8cb2c0ad198c507d72c1ecf7"
    sha256 cellar: :any_skip_relocation, ventura:       "96079d6d3345b1baf0a22e27de801802d9e2209b8cb2c0ad198c507d72c1ecf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9b61e5283c4f91d75fec58f05a837a9bae3541ef9725845ca7032da6f44c25"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
