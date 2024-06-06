class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v1.11.16.tar.gz"
  sha256 "ae37854e1404038d150c12b81bffdf472166bccb901b28600a0ac29018db0c94"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "660923d69049f52e54b38b8ffa4de07876a4162321bc81030c7b46be68477146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "660923d69049f52e54b38b8ffa4de07876a4162321bc81030c7b46be68477146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "660923d69049f52e54b38b8ffa4de07876a4162321bc81030c7b46be68477146"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c3d8b20b2c412ab78050247251270cc5adc6bcf9e45c8645c8061ad1f25171e"
    sha256 cellar: :any_skip_relocation, ventura:        "3c3d8b20b2c412ab78050247251270cc5adc6bcf9e45c8645c8061ad1f25171e"
    sha256 cellar: :any_skip_relocation, monterey:       "3c3d8b20b2c412ab78050247251270cc5adc6bcf9e45c8645c8061ad1f25171e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3f9137d78046d8c0633b0edb4b26aa14c1f4626bb79dec54ef79f52419012d"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
