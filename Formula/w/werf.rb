class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "5f06a249a6818b2d07b7d993770b0ba029a5687be156eaa586f90787e37a6796"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb226e9f6c1e9df181a8aa08ca4371616312d07563077acd0c85eb429c5d17d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5343e13f0bea3628436c0c6fc68ea2caf637cf31b82f999a74b22542b507b126"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5a39ba38b407536a37c20e24b1f84651757e2d0e5b3c63766128650c61e400c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae401a7243f8fe7ec24419a6129235644e354b295840622b7e19103a5a804ac0"
    sha256 cellar: :any_skip_relocation, ventura:       "f7c2d44c9b7d83847c49dd91ddc428bfe3e96091a9b4d72ede8530dba487a390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184cbafffec12f38ef4a94a9c7efd2c0ae9551d5863b1e84bbe581a044ba7ae7"
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
