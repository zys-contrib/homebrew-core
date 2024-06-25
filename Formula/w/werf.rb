class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "f5d554e3c902fa446a5ef3296e0759a17485ba9755cc68fa4e20bede7d071398"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "403ec00f5886b562c0deabbcf49d427598afc5a65330ec3bd6306bcc5ff825ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3949e403342acc36f0d1549c60c4c07017c705c15e7d0a94cf43c1d24dc3ebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "257f335c808440691a7924ed89a301a0b0729f24aa219968b0543a6b31973216"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea6b41f46dc9d6b4752fc9c04e809584ce4b3bd2fcaacc0832aaba3dc3e37151"
    sha256 cellar: :any_skip_relocation, ventura:        "dff95857f499a6ba007a13daa251423c9d412d651d594a7d93075709fca59316"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb89fc8e704a7b4d75e7a5ae1f2a8f85036630ce19f439eea45d5b569654a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a59edcc6813bbf118f1e54551a98c552e617e8183c4d0567433c505019eb45d"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
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
    werf_config.write <<~EOS
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
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
