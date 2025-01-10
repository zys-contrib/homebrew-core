class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.656.tar.gz"
  sha256 "c5523f2381b3a107a0a4f3746e27c93d598fcac4d49a9562199e55c3c481fb10"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a404ff0cb0e5f9c7242a5ccb467afadf449c21657e79923c9167c43a178a4c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed9aabeb638de5ec624b20ecc9542600cbbb97329cbbdd65abb61fed39d63d64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7612b2aebe2b8808e34021e9660e959568610ce7c91c5a42aeaaba08c2cab1e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f00e4788b191d7a372455ddd0cbf8bad725d783e0a8525d2a6e87f14fec0b51"
    sha256 cellar: :any_skip_relocation, ventura:       "7e14e7e1bd8b5c1cbd6ddf31a5ac5aaf868b934fb536d837f846af67423872d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be070114d07b00d4e062d73482842ed96fbfaa3015241210f78726143ea12103"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
