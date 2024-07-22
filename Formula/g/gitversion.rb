class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.0.0.tar.gz"
  sha256 "b0de243cbf3a59a1415efce35aec8531caef17dd05562d18e9777f98a4a4b973"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93e6d2233a255f3d25679f0bc279c3c3106b70d919b38aa32663e371e0ed8994"
    sha256 cellar: :any,                 arm64_monterey: "984d821555ebb343d16d9f8652f374317b68a0473f631db8cc9733e86bf98d20"
    sha256 cellar: :any,                 arm64_big_sur:  "c267e42278780562b5a63f4e4b4e18cf6fdf379c68aa1e8d8f35849d6f3eeca3"
    sha256 cellar: :any,                 ventura:        "91a3e18cd1327b71e0fa11e24980b86c26eb605d932c42b4d87393b2d23c2f3c"
    sha256 cellar: :any,                 monterey:       "6fa2d451e80962aa254a703aaeeceb96bc593261fead61d78572752ce5b8a688"
    sha256 cellar: :any,                 big_sur:        "0d4a39ceb9e8e68908e95996371a83f6fdfe3264f9ae89ecf6fa8fa7feddad0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "145cf97b7cf3542f18a5cb1bde69518a090672cdefef3c6681ce4f5415934c6e"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")
    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.0.1-1"', shell_output("#{bin}/gitversion -output json")
  end
end
