class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "9674aee1ae2b32552c44c2a8fb520b838f5340ff7d90bf94f5a7ddf5df6d44d4"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e96ad474253dcdb1f6300fb3c81095bcf2e48829c1a8ec2af03b99a3b72ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e96ad474253dcdb1f6300fb3c81095bcf2e48829c1a8ec2af03b99a3b72ebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6e96ad474253dcdb1f6300fb3c81095bcf2e48829c1a8ec2af03b99a3b72ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "499108b76825c2602ea9814aa69c93acd75be98507d0c577071921e55d9ae087"
    sha256 cellar: :any_skip_relocation, ventura:       "499108b76825c2602ea9814aa69c93acd75be98507d0c577071921e55d9ae087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982cb424994466bbf66f3f2537c2bc3e1814d4be6774d6e26a4e68234ca5e689"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/SpectoLabs/hoverfly/pull/1171
  patch do
    url "https://github.com/SpectoLabs/hoverfly/commit/e4aae6a3fa53acb444e3fe12ae2ded1c1ebb915a.patch?full_index=1"
    sha256 "2b31220b440026f8e6a616760ff1eb67b58cc5dac73beeaa6a2c5a1eb6a18a99"
  end

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
