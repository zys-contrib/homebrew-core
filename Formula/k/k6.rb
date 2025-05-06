class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "790e8a1d1171262095edbd5df5a74f18406d11ea88098560d0f18b7614c8b880"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995d62c03ac9a167a8bdc4a2e50bc785f8465223776d66e068c7071d8a7515be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995d62c03ac9a167a8bdc4a2e50bc785f8465223776d66e068c7071d8a7515be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "995d62c03ac9a167a8bdc4a2e50bc785f8465223776d66e068c7071d8a7515be"
    sha256 cellar: :any_skip_relocation, sonoma:        "44bb4d7152b3e5ce2d77515cde59ecc693979a9c9dac41a7479b8d07a4774bc0"
    sha256 cellar: :any_skip_relocation, ventura:       "44bb4d7152b3e5ce2d77515cde59ecc693979a9c9dac41a7479b8d07a4774bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353917b8a8fa1a2a38549cbbf37e1bab712139f5b3572f3d75ee82733f62addf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
