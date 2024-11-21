class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.119.1.tar.gz"
  sha256 "ff1f5a0a2cca9a4adf36d70f7a0dd43e9345fc8caed7692355fd7381ef01f914"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda2388f4a7a40c5bb0b69dcf909f456378443f25a55aa7b5d5ae4f83ad6b0c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda2388f4a7a40c5bb0b69dcf909f456378443f25a55aa7b5d5ae4f83ad6b0c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cda2388f4a7a40c5bb0b69dcf909f456378443f25a55aa7b5d5ae4f83ad6b0c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c49257416fe5ab87a1316c088359bb86b547c57fc957a525c87118d7549f875"
    sha256 cellar: :any_skip_relocation, ventura:       "6c49257416fe5ab87a1316c088359bb86b547c57fc957a525c87118d7549f875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5926455c031bb872e44579e9a55976d7e96ee8b11de5fa341dfe10b2b814b118"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
