class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d5e2a5a0a568c46b408f82f981ea3672066d4496755fc14837e553e451c69f2d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37536ae9e70e4244174267114d5727b34d002276e3daaf09ab03eea059288915"
    sha256 cellar: :any,                 arm64_sonoma:  "bd263f8dcf6df3bc14102c2300a2735c07e3ca4d03e89d6b461c1266f64bc993"
    sha256 cellar: :any,                 arm64_ventura: "5063d18c73c5f99151cfb9c7bf9f057e401264104c2106198bdaf9d4ae1e1dad"
    sha256 cellar: :any,                 sonoma:        "6a6a2b672032b44124896ae6d4817e9a8b4e86a69fa8fedc7eb15f28832cf4ed"
    sha256 cellar: :any,                 ventura:       "5223e5ff55ff03b1aa3e6ba8621da0351156424bc6cb6657b0ffbed528a6414d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4cd16d0a2c3941d7abc2fd59a437ff96fd62b4f6dd552d52f1a8af4b8286c32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system bin/"git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output

    linkage_with_libgit2 = (bin/"git-workspace").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
