class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.66.5.tar.gz"
  sha256 "06d12e22302ab10bdc1a20e07b84f1f013ce4177827f794c0eb777a330dad17a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09f9ce3bc50b4d850d78204ae1ee189e255bd8e3fd3e31e18cc234de4565ce94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5adcf90e18389ae74540c336f8728b2c69b8c50ed6fa5b7740f6aced4f9308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f007db8ed769a21024bea92dc755030432ca44bc25f082e3bce880688965ad28"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1c7ebcf6b66c7cac61414ac980d61c73ae005e87c25b7875074cfc9475ef821"
    sha256 cellar: :any_skip_relocation, ventura:        "fa2d30a69a1dc704ada6283ed3eac05d7c01fcb854a168556dad0f61fa8d1357"
    sha256 cellar: :any_skip_relocation, monterey:       "a93f1a129c2dd64704df212c21031b567244b8f87c029ff8b4e22a301373a224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "066ca214f080ace043bc4288e3629a55101eb8662ed67e692d968dd4a4164931"
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
