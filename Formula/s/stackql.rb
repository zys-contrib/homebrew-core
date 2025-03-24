class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.6.122.tar.gz"
  sha256 "911ff6415f09eeee290fe462915777a26722af6245be0dd1733bce59c8e67f66"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d3c6637d140a68c23053f71dba758191408a1e1e2f80f8e615b1488667eab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c72254c602939e54a82f59a00caa34ed089129a24012799aaf5ce151f24f9dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f17df7aa27a136d15323f4a2bbf761be230e2874c077347ce32d54145d2f22de"
    sha256 cellar: :any_skip_relocation, sonoma:        "811b8836e48948e6decb8c2996ea798fb7d1c2051eb78cc3eeb74fc18277dae9"
    sha256 cellar: :any_skip_relocation, ventura:       "6bb8d049283604d288bedb974a06f31c312de5a683805f51fbe36f0ca9e5c37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b794507b51e33ea49c2b3b405f9f9b6ed75e9e28c74b09bb7e53c45ff8fceef4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]
    tags = %w[
      json1
      sqleanall
    ]

    system "go", "build", *std_go_args(ldflags:, tags:), "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
