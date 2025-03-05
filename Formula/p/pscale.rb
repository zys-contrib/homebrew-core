class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.227.0.tar.gz"
  sha256 "53d5db6df5c9ee9e9bea88ed76a021adc09adc226f1f93eda49482cc7b50b2e7"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7898bc04589af283bb0bd35e6668eea20194ae3f831b175295b4c5dd11b6054a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35134205d9fa599386f3027abe272a4ba391db014f229dba3d4bc00c583a1d1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e33ea12c627fc2b605c79d44c0515fb1605e1c426bc97cd4fe6d0ac05533895"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2dfc876b2cbf7dc225e2251b0b62ad333a37bf0d50a59c08b5b90c2c708936f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c36f43606f2198ebe3041a1176b3109edf9f988b7928140b59d8e76c070692a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e26b33ddeaa49533be513fbc1a0899f1d82cb3ffef9437c129029317b8207b5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
