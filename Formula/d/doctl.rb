class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.123.0.tar.gz"
  sha256 "061f85a79a39011d3f71c9c75762d2316e96cfb1c9e6dafde419d23a977f4b9b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b373aaa235ddd9219ba11f0b4ea4237e0160c4119a529c15e05d20cf021e962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b373aaa235ddd9219ba11f0b4ea4237e0160c4119a529c15e05d20cf021e962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b373aaa235ddd9219ba11f0b4ea4237e0160c4119a529c15e05d20cf021e962"
    sha256 cellar: :any_skip_relocation, sonoma:        "700c4047ae35c6d8d1090ac058ad09c7f593e636a725e9748f447a931a3b7fe8"
    sha256 cellar: :any_skip_relocation, ventura:       "700c4047ae35c6d8d1090ac058ad09c7f593e636a725e9748f447a931a3b7fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa3fd3793e2a4341c8e2114677fddecf8d927803d0ecefc7f7db70d0472a045"
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
