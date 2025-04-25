class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.5.1",
      revision: "b2c4f550ee73985df05e5cca2595ff3d285d37ea"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80d24a4b5c8e8a22c19c77e0987be9789c65bcf809df069d156626ab8b665a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cefd90cd074c4f3ed908080d45b1f4df9a838505fa7ec583823fcb322261488"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed1180e81620b6f28c4840ce71bf23dfb60752fb434016a7012f9e993bd729b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "296522b8b183ffdefeb7d264eda004a3b29d28539cca38a61ef82e916378ad00"
    sha256 cellar: :any_skip_relocation, ventura:       "0f48e0a38fafc99111d84c0ae8d73fbffc7dcff84008e373229e902b476238b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8548a375eb1a71f0e337d6f8dded55bc4ca46f23f0f50c2e2e047e73f27e7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e5672181a188030fdb6035abd42f44d9c5273cac957e9cd4e43db5b9072bf2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_path_exists testpath/"default.project.json"

    assert_match version.to_s, shell_output(bin/"rojo --version")
  end
end
