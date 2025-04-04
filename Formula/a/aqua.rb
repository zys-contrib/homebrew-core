class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "39ce65ebe390dad7801e75c413eea04bc6d57d110784d6f7a5cfeebfa7d96c4a"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee4645c593316834496ab21e7629b8e0aef044715ce6f0c86dcdcc16f69cdb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee4645c593316834496ab21e7629b8e0aef044715ce6f0c86dcdcc16f69cdb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ee4645c593316834496ab21e7629b8e0aef044715ce6f0c86dcdcc16f69cdb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "28abe0995595b4a418958bc85eeec8e9c14200e7683296815ae22186873fcb1c"
    sha256 cellar: :any_skip_relocation, ventura:       "28abe0995595b4a418958bc85eeec8e9c14200e7683296815ae22186873fcb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93dc0192d637f3889b24954d2e04168967c51e589ea7fe4a358c9476a3237b1b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
