class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "05acff46173b2123b5f2ea60f9da8241eb5cf250e338ee226ab425e824857c17"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da8e5dc6d3fbe09b3d2530e1ef9bc832be213c5817b73770ce84e41bbef4fe16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da8e5dc6d3fbe09b3d2530e1ef9bc832be213c5817b73770ce84e41bbef4fe16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da8e5dc6d3fbe09b3d2530e1ef9bc832be213c5817b73770ce84e41bbef4fe16"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d1adf203341ea55ab3cdc84ac64ed618d83282e8efe706275bbe430cfde8d5b"
    sha256 cellar: :any_skip_relocation, ventura:       "4d1adf203341ea55ab3cdc84ac64ed618d83282e8efe706275bbe430cfde8d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46cd1f26fe4c79c7fad77e03ad59daf608c687b64785b8ef19563997355c2f2"
  end

  depends_on "go" => :build

  def install
    require "net/http"
    uri = URI("https://update.k3s.io/v1-release/channels")
    resp = Net::HTTP.get(uri)
    resp_json = JSON.parse(resp)
    k3s_version = resp_json["data"].find { |channel| channel["id"]=="stable" }["latest"].sub("+", "-")

    ldflags = %W[
      -s -w
      -X github.com/k3d-io/k3d/v#{version.major}/version.Version=v#{version}
      -X github.com/k3d-io/k3d/v#{version.major}/version.K3sVersion=#{k3s_version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3d", "completion")
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end
