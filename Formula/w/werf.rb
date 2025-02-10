class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.26.6.tar.gz"
  sha256 "37741088a6f3ba19c9b6645709417d5bb8fe9c62389c7a8369f74f97afb0fb4a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b291c5387ee8d33b2be94a2867f6d7bab8ab161f92f12486dcb300c8c14da313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fad94865020c47544ca31157c64360ed43913c082af69538e87d5349e91553"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4502df8988785dcc49f277fa29a0897999fa420289f5487ee2a814120dcb5d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "0acb08a593b7558782cfe3204bbf06330f2432d19d4d987781d38c0e46a89a99"
    sha256 cellar: :any_skip_relocation, ventura:       "1b11cfa1d567515235c98fef8b55d2a578afca429198eab5d411c01bb91b8807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436222d6a11188142f75468906f029e93eeabe5170f4e08adcbb7cec1716a16a"
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
