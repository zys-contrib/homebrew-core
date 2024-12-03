class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "9fdf84bccf35cd7c46f1b6a7e1cbf2e1d1838dbad9d4a23d91ba71012027ce51"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53835e3405a4657c7c984f9de5b9b41d3e06df0465797f3f37a7165f8edda35b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da6042226ff9101c476a44a2241f0112d7cf1a20455637032deba621ebec8b72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd8092bb27912d178301810588c899d5b1378f25e974106ba3047d3192395ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "27e5f323e116e40782adee54e3142a8965b20f351719b92dbc37fe7a6d8e898f"
    sha256 cellar: :any_skip_relocation, ventura:       "043d3a0e1c1f47d2660cdbb6e938665278c7efea2455d1786a6bbd769d650417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125aeb47fd773165756c4db1483e8f4275908945fa387c192ae8e84c7f687aa1"
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
