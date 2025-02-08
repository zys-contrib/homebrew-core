class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.26.3.tar.gz"
  sha256 "c650c5cda19418b9523afb89e8101bf2872635927ac81b098ce69e51be2fdd53"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77741e7a7a523935858303e38686c5d1981a4c37b87e25e0220ede5ce331bf8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c53beae0e5252e426b78bd336e427162e9d4e423cc3695265c24d7a3f01dccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e67fbfbf4ee2573167243cd1a84fdf66bdfac7c0d36fcec23f1707a869cb8c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3648c9285451302950b3956b353801f2873e0bb9cc4a0dae2282fa2df16755be"
    sha256 cellar: :any_skip_relocation, ventura:       "4d3f80d0f116c35a9abcbc7be53bb92579429984082eaef8764adfd16f2d5782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2102bc59f9d2a904159ae64aa5b242a4aa27ac15c7fb6d346bba813ea53e9927"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

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
