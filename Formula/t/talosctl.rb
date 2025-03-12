class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "7e1b54db4f08b00ba07e273fac08ae708f53a230b4dd0868343f08c120f93b6f"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a74aaf468eb95139c94da174cbb692e76a31e42120d83c670208395be659c277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a219e50302201ede8efed1b1ab25d871af8b5b2cc13ae38173ed0bf726cb8d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbb44ef911f265785424f33b464fb407666e3d894f2f370d5de916d90ad6d167"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde98185359f5c60a460acc9198e67fb85bf03ecda4e57422789e09d86d4eac2"
    sha256 cellar: :any_skip_relocation, ventura:       "b5ef9d33fdeac48f67c03b15163ff51321229ed253cf63bc38eb8e0d1d1155c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34071472fa0aa4854d7e841fe1ebeca1dcb883d9d7b2a1ba01c06145824cfab2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
