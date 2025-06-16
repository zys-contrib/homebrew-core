class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/3.4.0.tar.gz"
  sha256 "3481af7619fe80658d002aa1f39493c973089e5312a2b7ef5a4aa8316e96e661"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "646daedb56844f48e097ac460b2414b46c08d8418c7235de0bdaec0b61efdcc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646daedb56844f48e097ac460b2414b46c08d8418c7235de0bdaec0b61efdcc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "646daedb56844f48e097ac460b2414b46c08d8418c7235de0bdaec0b61efdcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c4f9bc65a412bffc3863284ad8333664c5ed82f81ebcf60169bb0f996287eb4"
    sha256 cellar: :any_skip_relocation, ventura:       "6c4f9bc65a412bffc3863284ad8333664c5ed82f81ebcf60169bb0f996287eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3448830af78299cf31bba42212102eac7beeb16a6b197c32f3685928f54ef80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
