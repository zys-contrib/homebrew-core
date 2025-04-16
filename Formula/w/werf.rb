class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.35.4.tar.gz"
  sha256 "32fe89f9f8105bf64c8b9d104af43a73737afb3e9bf7004be58ab096ace21ac9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2742ebfb2f9402c569c9bdf89bc8460ed4caa37cb681ae090ab0601006e05e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5f322ce3e47b4b65e63c9f4c6145fe8ae9f8ac5f5121a50004775af47e14174"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "088bf6a77911fd2ab8dc9d08508c86c8d545d3afe14d14ff7e2c473c987af0b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a6cf9b56fce9d0c82ffc0f62b7fc90811c9f6a02bede0437b4ad0c01982fc87"
    sha256 cellar: :any_skip_relocation, ventura:       "65f66d4cb9922da43a28962e91d8b937455196fa6c46ffa18327f9148b0d9f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30554ed50381acba721bdf9935b121b753b39daee9783d9eeb7ba89f57f06623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0e6702c333a957c1a2ee1c6f7f134bf95f5321fe1927ac83387fdcacd744bc"
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
