class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.62.tar.gz"
  sha256 "1d6e0669711a8d8940b1d71b2b0329998eb42964ceda2da2cd39d40149bea029"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "375542189a7e911f51493bf2521c901f72688dd1bdeecf5367e4609923035669"
    sha256 cellar: :any,                 arm64_sonoma:  "ec98dfc633be8abdf9ac5a4ac45ec4c009a0ef63266f6f8680b641fc097b4525"
    sha256 cellar: :any,                 arm64_ventura: "b0e81a0695913eb8c1acc29f95cf63bba3698084a74cd9922f73117fad3fbd63"
    sha256 cellar: :any,                 ventura:       "6779306205af0efe53e18b00e5fcdde336c1273c96f5d7ed3f53adf57da2641a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f52cc4fcc79f9d8b1474da71d258305f27fb31b3614fa6a5aa8c5b63d991f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269ee8f334c463551dffbf5f05f86bc9c6ce3baf9b29bcf7db7b6cdcbfcb1bb5"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        # Fix to cmake version 4 compatibility
        arg = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        system "cmake", "-S", ".", "-B", "build", arg, *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
      end
    end

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end
