class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "2056db443c91290c33e4c9c7d69ff35a02798040523da71b76f7f0ec1ed23d89"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddb79b800591b1bb85d8e20ac47036855dd65ea6ed39bb4f4847cae677e596a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddb79b800591b1bb85d8e20ac47036855dd65ea6ed39bb4f4847cae677e596a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb79b800591b1bb85d8e20ac47036855dd65ea6ed39bb4f4847cae677e596a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7425c4db6374750b457128d2ab57fd374f8de3db7ddb2eadfe3816a93d48ed7"
    sha256 cellar: :any_skip_relocation, ventura:        "a7425c4db6374750b457128d2ab57fd374f8de3db7ddb2eadfe3816a93d48ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "a7425c4db6374750b457128d2ab57fd374f8de3db7ddb2eadfe3816a93d48ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc6791d3f5de9b381eb34caf4a200ee6d835c20c5044b627c4bcaa32d4a58212"
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
