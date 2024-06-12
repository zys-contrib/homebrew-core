class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.59.2.tar.gz"
  sha256 "0fc1e4414441b1e86f036ac74ed6cf9d8ebbfe091a508267373ba25b805734a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0e9d727cdbc6a3e6d1832a791bdbb592f9b4e89a977235ea580d20dea26a869"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "377f7d63ca8f4c0f83d26363873c6b982db2a03f6052e330d59d3de06e3bdc03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8df68f78242774f0506596f3381efcd60e326cbe59c7f3c04ae14cbaeac1b49"
    sha256 cellar: :any_skip_relocation, sonoma:         "f19f849a34459fda129f55029adec654e48b204a0cc525815fd5c250c5e4f667"
    sha256 cellar: :any_skip_relocation, ventura:        "948b17b65a24e20ce167c29db566064ab551619f52c88cdc5ebc7b87315a1755"
    sha256 cellar: :any_skip_relocation, monterey:       "89b9b08d8f4d2b3b5f6ed926ebda20a6c9ca81880b6a7ede72b67491e8c0b7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f573989dba03121e5afc609a9802f5baba1147dfa6c2eac29536362a34ccb73"
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
