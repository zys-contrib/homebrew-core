class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.8.0.tar.gz"
  sha256 "334d6ed2f739e9a8fbdfa478d8e2461e5d439a2b0c5f73ae97406e490ffc44f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e46390954a3eee33dc9b17ee5b6514747d75568961bcbe0d8e7b7535ea3b6c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cc0d17bf702ab50faa15d1e758f1bde3a7abf85a5b9102555e4dc497b61e787"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4312f1a23558f2c1fd310df7c4e3f5a9937047d1dedfb2cbf59d17f24bc8321d"
    sha256 cellar: :any_skip_relocation, sonoma:         "290d708aca66729a9c825c707cb0ecb0d1abb589fe601a195e9077d6a46662c2"
    sha256 cellar: :any_skip_relocation, ventura:        "2d05c55697c88376fdd8fe94e24cfc12d532d045ba957cae12cbdd556cf04dc0"
    sha256 cellar: :any_skip_relocation, monterey:       "54425e9babdb334fe70bb8510ae58a44f9ffa760cadee76378c9a3efa83fb2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8724dff5a060bc7b850c781c354edc04fc96afb9cf68749b4df95ae4770560b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
