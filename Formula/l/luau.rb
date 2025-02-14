class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.661.tar.gz"
  sha256 "d55c99c8df926c600eb2cf654aa5c1c357e2715bee6b2b6cdaeb13fbc45f3f9e"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52e58a10701e7f7d29374933f5fa58d1128dd3e2eb78f2b6434b8529389fb7c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a391266a3a2cfe136c66aa73d2a3dbbd078970706620bc570bf7d05c581be5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f861a1c047641f39543ccc0daf651b18e357532f80f9411fdd084a4cb6a0dda4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3865a979e94e666e092aad4ffbbdce21253284c44b68575e6059cca4929008d"
    sha256 cellar: :any_skip_relocation, ventura:       "8f78073a8da15afc8dc387b93705bc2e5f84267da3f13c1e19e1b8f769fa4225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0cb6bb8ef7887a08053f0007317a61deb021f3a93c6da911c9689eac1761f5b"
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
