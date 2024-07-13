class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "a9dad9e5bc9edb1111b3331d1ccb25f97f2593f51b1557a36c1765df08cb3006"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a996d11e30fb44b10e0ed54784d24b7c97c18bd212b4285c4607177338d7a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fb3bc02985211fa49327940a714205b976082f49a6b4122379a3afc55d23531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8e18b03b7d9453c477e8feb1a92a5945f6cbc0a5f8e8784904b53b6ee2f9e9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "475e7a9e12d54532af30bba4057a58721e046db433738906b75f3e9a316e3cbc"
    sha256 cellar: :any_skip_relocation, ventura:        "f1ec91b9f5b4ee43056f70a06497af5f98cd731134014a8eda5dc754bcd6c7e5"
    sha256 cellar: :any_skip_relocation, monterey:       "2a85ca675b0622d6fc468c0de6e2c9e01f9d2de1b6d9127a24cd8740561dbddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e330c1c8705ae09372eb4bf41edd0fd54289a1ba43d2d35e365b834f08808656"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
