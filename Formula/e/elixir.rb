class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "8e136c0a92160cdad8daa74560e0e9c6810486bd232fbce1709d40fcc426b5e0"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eed23c1010f235df8d8802e39bbfc2d23b233491e87a31339f912cff60fad1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2158b8123d1235f4de4464b2f63cd3530f982fb89bd89345c1fb9917c9114270"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4fce76a3bdf9e34f7e3cf295a8cbf7b70b3013ae630b27e5e834e524955aa04"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d7f31525636360f1d89df53fbd7e8ba853720996032e9cc882e68692680b61f"
    sha256 cellar: :any_skip_relocation, ventura:       "5bc5fe4ab49f3271331228356dff2c16f98ea43b88171d0e6f5da4560c8ccbc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "895ff1d6c4695ce3c13ec12bd9e252960f044e614b3ea44a5de09d38ae92e6fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b5100051dea202f948f96d0c87b741799cf9c12ec767afc9a013eae8b4bdbc"
  end

  depends_on "erlang"

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end
