class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "6cb1052356177c1a6972122d7c6395448a65b49f548f63303bebf45965810733"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f1a275e68af1df7a8c49be86df7c27ae46295c932a3ac0dd53562f730a508e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ada9ab66056cc79ac1a7e5b6497519dc291c8f2de5afd6032ab581482ddbae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2ab30a161e86230d4c29bf3a7f77477ff824016507147382a58e314a29037a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "316e2e73ffbef820214292aeaac3e5f82a70564c28d8fa1110569aa99c1907b7"
    sha256 cellar: :any_skip_relocation, ventura:       "dbfcf8215b3a83c9b2453e8f62302a688aa9c5e4430a8357d07a4e148447f8e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6094c449e0bb09cf40df5a9694896271aa88ea1f01e8b7f95d16d9b44a3b52a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eceef7ec9f9775ead999f1d50a1e82de41cf3a907369cf0c344f88d66312459b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
