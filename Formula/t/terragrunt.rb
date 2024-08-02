class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "f22c6bc570d0f97bb083e7b3363d01d664551b378ee452647ffe296677f9d3ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57a2fade5d68119513559dfbe5faddf642a8aa6c6bc46c653caa7348adea13fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79a6421d12cc87ac5aa125caca84058ee81ad838a1663ce8c45f7942bff75ad5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "266bf106129d340b926897953e832a7ec50d67d3b6fc902cbd6bf8ab289d963c"
    sha256 cellar: :any_skip_relocation, sonoma:         "097b3dc4b2af4ff428498237ac1c6753d31ff24c41a95fb1419e40a79652ee0b"
    sha256 cellar: :any_skip_relocation, ventura:        "156012ac54b0de767369abfc3f9189a763a22aa739aa0aefe69005c17be46e17"
    sha256 cellar: :any_skip_relocation, monterey:       "78f916f3f2c29bb661fb69b7a80e21c48b98836b9077decc38e33d8fe0abee76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a8967d79dc9bbade369f5fa2de2036f8105817123e401c57fcdc038493bccd"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
