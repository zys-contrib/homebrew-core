class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/v1.50.0-0.tar.gz"
  sha256 "9d56b793138a2e7dbf53148740a3ee4777d2d51842d175ba85fa907d71f079dc"
  license "Apache-2.0"
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6fc436592e7512c75133cd501da7005a0ca564122198a20cdb28305ea0dc7f4d"
    sha256 cellar: :any,                 arm64_sonoma:   "8eee983f433b14404e806a25d9d9d6a37dea290ecd07676eea143c244aa81b7c"
    sha256 cellar: :any,                 arm64_ventura:  "5b52e62605db4618b943a313b7dc27fa1ca4d606289f773a934d62aa841ce822"
    sha256 cellar: :any,                 arm64_monterey: "4ead7a7d5a515244136e919f531d24f1b9ea4ed01847476b0f1b50d5bcede873"
    sha256 cellar: :any,                 sonoma:         "b573480537972f4d8479623184281fc3e5b78a3e8d92e8b5eaf743db9584e5d8"
    sha256 cellar: :any,                 ventura:        "6dabf92fc2281a8c6f92dc2a58be611da35160b81daf54dc496cae8d6c63016c"
    sha256 cellar: :any,                 monterey:       "fbb502ebd96a09cdf7bcc97a2e675a90d1261598bbc198eef328b06f524eaab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd96aeba470693fd6b86ed66ee7fc53171dc7ee04f141b69423b1301beddcc83"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.14.3.tar.gz"
    sha256 "db8ffa2c5562fac4fce5e5f48fd25763e79190af5e3d3d91f0699e4711cfbf10"
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" unless build.head?

    args = %W[
      -DWITH_SHARED_LIBUV=ON
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
      -DBUILD_MODULE=ON
    ]

    system "cmake", "-S", ".", "-B", "buildjit",
                    "-DWITH_LUA_ENGINE=LuaJIT",
                    "-DBUILD_STATIC_LIBS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildjit"
    system "cmake", "--install", "buildjit"

    system "cmake", "-S", ".", "-B", "buildlua",
                    "-DWITH_LUA_ENGINE=Lua",
                    "-DBUILD_STATIC_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildlua"
    system "cmake", "--install", "buildlua"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    LUA

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("lua test.lua")
  end
end
