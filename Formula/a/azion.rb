class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/2.6.0.tar.gz"
  sha256 "077c7be4a91783d4bd727d19af88fe5906afd7e70babae9d88a3fb31dbd831a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "612aeb2d9ac6377ff19e116504d617fbd6a09fe486d858a75e07fba525cd5119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612aeb2d9ac6377ff19e116504d617fbd6a09fe486d858a75e07fba525cd5119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "612aeb2d9ac6377ff19e116504d617fbd6a09fe486d858a75e07fba525cd5119"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bdefebbb2d7df2f6f0866a9e0cf2cef82ce04d4ca679d1825840fcfcf540b1a"
    sha256 cellar: :any_skip_relocation, ventura:       "7bdefebbb2d7df2f6f0866a9e0cf2cef82ce04d4ca679d1825840fcfcf540b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2d9e0f0df6a55bf7789371bef9dae023994319309d961cb9811c1b6190f758d"
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
