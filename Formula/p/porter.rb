class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "53d73d6c6afb6b4bdff7072aeba4ff14738d9a09710cfed9ff5e84b649275917"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d907ecf54616e5d64d085c53ed5cdc47ac4b641146f26899225826c57c4d1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3d907ecf54616e5d64d085c53ed5cdc47ac4b641146f26899225826c57c4d1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3d907ecf54616e5d64d085c53ed5cdc47ac4b641146f26899225826c57c4d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "74f2adce1a3778289c719e4fa60c9da60286a0b27ebff36cd93eef7903112290"
    sha256 cellar: :any_skip_relocation, ventura:       "74f2adce1a3778289c719e4fa60c9da60286a0b27ebff36cd93eef7903112290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5baff9f321e3fd8f7c243ce26c98173c8876f1f47af8f8f6af6279ee1a169d9b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", "completion")
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_predicate testpath/"porter.yaml", :exist?
  end
end
