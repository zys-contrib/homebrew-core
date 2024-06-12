class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "eb9d2501bb7addc9b6b10c21bf9f41ce5c0b57764ff74c0fb3cfc28b2bf58f7a"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2168c1e96d63a2e2ee5c17c0d7acfdf3b6aeb94bbdb80acbb7cb802bf04078a3"
    sha256 cellar: :any,                 arm64_ventura:  "d9811c3dee62de48f686f1342ec33f8c3652153f928ba8d233599b5e72c6046f"
    sha256 cellar: :any,                 arm64_monterey: "80c978397e39e7b5ecb8b669bce50e87ad60cd1a5c5e7045cca4ea278314b995"
    sha256 cellar: :any,                 sonoma:         "82b76f7098368b82fc1ddd00694b6074c8afa65749cf504d095f64c1f1f8c54d"
    sha256 cellar: :any,                 ventura:        "7d75817ee6bf1b8f3aaf19af7332fab130c37cf6607b1165cf09b361e0953ade"
    sha256 cellar: :any,                 monterey:       "e7e9315021028e47c66d7158c417118712e924d411e309ed770334e2125d3f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2bff806af433ed1af51cf0aacdda33b96ca06eab67c016011b3b2a0e6a9e728"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"pixi", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
