class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "8a20197eecc22595dd0dde79695012e301bf75013ed30429ff98e53008576036"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a4da536d88f7e7612265527cb174e3712c0410c52246ecae36ba25a4c300dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221b2dc53a36f769b6eb9e8700912cd0bcb8ec49e10e3408e97dae5f8ae83ffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be5d773f78e7be24f78ced70ca78e09891ef510e0b49732e3e54461fab905521"
    sha256 cellar: :any_skip_relocation, sonoma:        "15633ac14eef255a965f3084b661fd807843ee9748efe937857e8b4246ca523c"
    sha256 cellar: :any_skip_relocation, ventura:       "a0fd36e4c892599f35a8ede0e5893b9a5c8a70322d2dc49335429902b857833d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1771eb0ab1ab946f8e0374c5f0013673fb04bb70aa190a6f6ae924493ca72df"
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
