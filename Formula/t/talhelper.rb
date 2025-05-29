class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.27.tar.gz"
  sha256 "e98d0cc0bbb5852c81fc220cf30b01535abf54fb48dd77edce201fcafe8a41de"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0d185d8414af0f31363ca5bb960b427b75209d420fb1fb05ff3f6525e1b9bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0d185d8414af0f31363ca5bb960b427b75209d420fb1fb05ff3f6525e1b9bc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0d185d8414af0f31363ca5bb960b427b75209d420fb1fb05ff3f6525e1b9bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28201748f339fb4063799118f37b879c684ce7729ba97951dede59d3a194dde6"
    sha256 cellar: :any_skip_relocation, ventura:       "28201748f339fb4063799118f37b879c684ce7729ba97951dede59d3a194dde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed47f6bdbf40cf2e5fbf71ce4915edd6c96e1d2678d565d3f2abb6a4743efdcf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
