class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.86.1.tar.gz"
  sha256 "82d5dbab4000c18754f928b48d328a151a9bb3bbb85d8b6a8c5dfcfdd0d51fd3"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc907df8d66784438311fee91889182a449f20de50a05425bdd6ffe57e65f75a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef6ce7199718da3f90b5ea968b8dd18012710e207cf490305fcff792d81c3aa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2ab5b3a415d0d35fd68acdcb8c5a7da2c4b483aec44a37aaa1e7fd76d85bcee"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f41c7c544e12ee2d72183c9915a0711b8c166a42fdeddbc934915e4aad94ab8"
    sha256 cellar: :any_skip_relocation, ventura:       "eff0159157639759f6d33ac3a16d424ef737c82bad7c3de61dae3962177740c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dd7178f119eccc94f18fed401a0f916be8e2d4ec38fc015630704db8284c3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46080924843380130d0df4d3465fec6a962ae328e40a3388641afe8f052e1f52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
