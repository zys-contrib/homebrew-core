class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.8.7",
      revision: "3ed59977567fb3e36e8b676de1103cc34958a076"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91417ca437da25a30940e4f81d89c1c4ddfd67e69538d0b4ddd305a0647abf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8a1f102321d3cab4555f3bde2509a072a9fc1db4fd079ca8b13720cd2ac633c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e2cbf7a7caed84e44b4582541a3787ae61c14b0fd5a630dfd3e81fe94812a13"
    sha256 cellar: :any_skip_relocation, sonoma:        "369899091d98a201067d84f6b311d41aef000c1ebf618f462629931d7c55f7e9"
    sha256 cellar: :any_skip_relocation, ventura:       "98b0623e3eef47b89e3c6beaf3caada305f0ae6fe329dbfeab2bca31ca135285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b7ae9bec2d0f4407e410b9fc1aad3d7f96d3bf1ab277b2d7d82de0c89ab68d"
  end

  depends_on "go" => :build

  conflicts_with "px", because: "both install `px` binaries"

  def install
    semver = build.head? ? "0.0.0-dev" : version
    ldflags = %W[
      -s -w
      -X px.dev/pixie/src/shared/goversion.buildSCMRevision=#{Utils.git_short_head}
      -X px.dev/pixie/src/shared/goversion.buildSCMStatus=Distribution
      -X px.dev/pixie/src/shared/goversion.buildSemver=#{semver}
      -X px.dev/pixie/src/shared/goversion.buildTimeStamp=#{time.to_i}
      -X px.dev/pixie/src/shared/goversion.buildNumber=#{revision + bottle&.rebuild.to_i + 1}
      -X px.dev/pixie/src/shared/goversion.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"px"), "./src/pixie_cli"

    generate_completions_from_executable(bin/"px", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
