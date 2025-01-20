class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "4fa1ab803cd1c531c30e24a2cecd82b95e50ac3d879e8c03ae6650f2c45dc8e0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68026a07f9568bb9490858a68f2d823b5255a71e2b4ef1637e68f236c19d28d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82b6b03506ac4c483997f3435c01b2bfcf5407f668cdef0348cf5157c6dbbd74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c307f598e902df4a59005a063f87ac8d54e59cce022aeb89254c4f3615c2cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8623365e5075c711cbec72a402ce25896e49142354fcd336d8163d511dabcc30"
    sha256 cellar: :any_skip_relocation, ventura:       "222ff4e97c1e6621ca8e7e08b15fd2e7a8f41c2f6b4d0f7c5a44864129bf20a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2d394dfec1f1b34eaa52fb8c26f6036b78f1aa3e6f4252368d1224dfd633f5"
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
