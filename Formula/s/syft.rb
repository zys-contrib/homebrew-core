class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "25658ea50cbd99571f5bdb9a32e5295a04897e0098001a1a033625fd5405e986"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1202de8aba860299d25dabc267a923feed97e2613d122c04fba94ccdb106f5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0cee587444e3b78612e27afbab0c1e7ef3e24eb91fef386c1de2314aa234dad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d53abd86a47549662e377f23a753416ef12bf6ceef7fd7cfa5ca9c5219402253"
    sha256 cellar: :any_skip_relocation, sonoma:         "3296225a0cbb90988544d2cd27936947e75a3931cf4e302f2d0bbd523fed37a2"
    sha256 cellar: :any_skip_relocation, ventura:        "760ddde917d3fb6a7123807312064679b49efdd73cd33af0b24de905fc207b59"
    sha256 cellar: :any_skip_relocation, monterey:       "f32c60a783dbfc1b981036344c71fb5bd6ac68a88b1ba0abc871649ea1181e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff6fabdd639d2ac43d5dd9b785c4f36529bd69bd2097dc78df3d1d65a760d3f9"
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
