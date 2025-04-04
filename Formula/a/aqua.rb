class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.47.2.tar.gz"
  sha256 "f3b84be00d65473973bac19d83e5f47c9d7fad0c57c46d226b9284f1ab4efb75"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abae07f4a15bc0b2b3ae7fc8a658ea02a8f75ebd60707b9082322341701dc5d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abae07f4a15bc0b2b3ae7fc8a658ea02a8f75ebd60707b9082322341701dc5d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abae07f4a15bc0b2b3ae7fc8a658ea02a8f75ebd60707b9082322341701dc5d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a178c1cd0027f35a964dccbe4d3b7dec66611f761c4b1ab44e67e328e61b648"
    sha256 cellar: :any_skip_relocation, ventura:       "2a178c1cd0027f35a964dccbe4d3b7dec66611f761c4b1ab44e67e328e61b648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdaaafb047de685416f682ca27f0668f6ac2ba395f791b1beede1885753bb44a"
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
