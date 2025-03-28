class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.11.tar.xz"
  sha256 "17af66935bfbbf01c4a8975d80e706d79744d907aa8bda75a96a34bbe64dbc06"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d284b3cf92334f63cfc9d458f4aee8883e84b55b33b1f9542c3499555026ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0d284b3cf92334f63cfc9d458f4aee8883e84b55b33b1f9542c3499555026ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0d284b3cf92334f63cfc9d458f4aee8883e84b55b33b1f9542c3499555026ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ae1a37aeaa6dce31864423ba332d073c58748f27e170dc04ee40be284d57b4"
    sha256 cellar: :any_skip_relocation, ventura:       "24ae1a37aeaa6dce31864423ba332d073c58748f27e170dc04ee40be284d57b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82a072c6bc7f3817a6f356209d7e793e123b7271f31bb68ca0b270b036fc6c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
