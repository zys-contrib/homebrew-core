class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "6f5e7bec94254af78d7604b493953337999f565a0e64de5efa669d31feab65cd"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43f6f8ab943f09b4c133aa444e12b760ecd2e7ae3278d10fe5d605d9dd16eb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c43f6f8ab943f09b4c133aa444e12b760ecd2e7ae3278d10fe5d605d9dd16eb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c43f6f8ab943f09b4c133aa444e12b760ecd2e7ae3278d10fe5d605d9dd16eb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "228eb69b8280ab5197106acfeef63243bc8a496d3594b690e94b39da5adaacb1"
    sha256 cellar: :any_skip_relocation, ventura:       "228eb69b8280ab5197106acfeef63243bc8a496d3594b690e94b39da5adaacb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cde62a0de25465cd5b4054c557cacc0d2a8e2ee67afe2a1ff55f063d68d0a8a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
