class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "92664a859fb27699855dfa5d87dc9bf2e4a614d3e54844a8344196d2807e775c"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "316df6cc7883f0019a4d8b7cea12981c76558ee23c91ce802d8a5a27f4e1dae3"
    sha256 arm64_sonoma:   "149fc485a57fe986e601b0072476fc7b52de0feb888dcac0e7c153459290f548"
    sha256 arm64_ventura:  "d9e1818484cce9f61edffedeb494e01f69a07d137880179f84dabef6b48b063f"
    sha256 arm64_monterey: "3b8de888365014ecb18fc427906bf5121c6f5c0b6eceaf8311ede6030b22334d"
    sha256 sonoma:         "bce2680561c7ce0a84ee72e598e4569382fe29ec44a156517c1dfd9bcc936951"
    sha256 ventura:        "e16a952e1ed4e62ab4512dbd678a85d45031a2157898d033b1a95de311619a7a"
    sha256 monterey:       "a662a8236dbfedeb36a8e291243fcd6c2c76fcb4c7aa1a2f34f7cdad6badc4f0"
    sha256 x86_64_linux:   "18ea26aa05700494f2acf965ad8db36bf9c1e8f36ca1c606091e1373effaad9d"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "zlib"

  # patch granite to fix db dependency resolution issue
  # upstream patch https://github.com/amberframework/amber/pull/1339
  patch do
    url "https://github.com/amberframework/amber/commit/54b1de90cd3e395cd09326b1d43074e267c79695.patch?full_index=1"
    sha256 "be0e30f08b8f7fcb71604eb01136d82d48b7e34afac9a1c846c74a7a7d2f8bd6"
  end

  def install
    system "shards", "install"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/amber new test_app")
    %w[
      config/environments
      amber.yml
      shard.yml
      public
      src/controllers
      src/views
      src/test_app.cr
    ].each do |path|
      assert_match path, output
    end

    cd "test_app" do
      assert_match "Building", shell_output("#{Formula["crystal"].bin}/shards build test_app")
    end
    assert_path_exists testpath/"test_app/bin/test_app"
  end
end
