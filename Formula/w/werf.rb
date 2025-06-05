class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "25ae794873cbd5d77c96b505bfbc1e5d10aaed13303056cec396c9dd67ff4850"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d8755d4f84a1206266b5ce2a4d58b742a029fab341dbe961abd5b79792a00f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb11fbdc62e92f9f98e4016f2b2133e0cf664f55f67f2cfb04c0555f75da195b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b15a86cf23876da0cc2563e675443a855ebbfbd8e5c961d2be6edec00892bb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6604f92ec6bfa90ff64b387162a4e6212ae96d48ad0e35896ba0482db26cb01e"
    sha256 cellar: :any_skip_relocation, ventura:       "71609c5a6566ec49eb27b1600a4ed2959b9c803716a4550b758a05af6a10406e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cfd0dcd98a09f62760ee08f53bd4ba490c407f5d41003d19d80487022494d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a4db5ae90e0efb61a11fd6c8ad3192d6d6857a0b3e8a2aa93c4a504a47fbd1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    YAML

    output = <<~YAML
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
