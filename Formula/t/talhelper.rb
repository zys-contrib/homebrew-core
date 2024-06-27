class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "8a39408770ef3bc943751475677e57f294255d770ee14505df3e60847a3661d7"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a55b9a3eea879617e83b01341e31851a9d2c655d61e1ff7a0c677759780b9653"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d997b95416c93874b3ca27931c25e197d811d689b419dd4832c2ace7c4486f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cc09cb590284911c3beac3ae0e0f5be86417b0f5bd16de0675eaeb582165478"
    sha256 cellar: :any_skip_relocation, sonoma:         "99e0e722943132965b63afbbdae38f85c00a66aed44f393184a4a22e4429f09a"
    sha256 cellar: :any_skip_relocation, ventura:        "8ecf12bb8404b2ab2b886bae81deadff18b880d84cb24412e88a23965a7e2a82"
    sha256 cellar: :any_skip_relocation, monterey:       "9246fa5769502e27b242737b66f0deefe0c61ef5a249e492f7b0ef532a090db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6666f138faccb65bedf18b42b6a6b76f60a393fa5a4ec86a8a4507c8bcad7ac"
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
