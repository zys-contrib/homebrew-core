class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.132.0.tar.gz"
  sha256 "6037dd2657b0b4cc27fed86808778cf86f8566ba655a5d04a31450416a975be4"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fceed93c15b4a865cb796905508972048f705f76ba1794b91ae6e740dd3c7df7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fceed93c15b4a865cb796905508972048f705f76ba1794b91ae6e740dd3c7df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fceed93c15b4a865cb796905508972048f705f76ba1794b91ae6e740dd3c7df7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8219dc7a6661033d2b933651727bebaa0735dea7efc33060e8b93aa3e6b3c586"
    sha256 cellar: :any_skip_relocation, ventura:       "8219dc7a6661033d2b933651727bebaa0735dea7efc33060e8b93aa3e6b3c586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2217a2b7738c465e2e1df3bad12d0b7d34d6a2a7a03ca8824e464b80de34c42"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
