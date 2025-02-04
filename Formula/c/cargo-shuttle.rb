class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "d377bb0b1c5a6ef01ca0b9eefc9af9549a24d90432a49c9486b431074dcf22f9"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7e0375b6ff7e78008897970d60d625da968968532a0a80f8466b1e6fb9682bd"
    sha256 cellar: :any,                 arm64_sonoma:  "d83e7dfee3f20a5e45fb9388904afe22e4552afa383b1d3a5c9178e906587086"
    sha256 cellar: :any,                 arm64_ventura: "859d686e36437d785ad838fb12f49657dcaf6d53a840048489332f4d663034bb"
    sha256 cellar: :any,                 sonoma:        "c45c44264a65ffc3d1ff6f4c934193f57f9cdf282ac7ac4f6d1e487c44777941"
    sha256 cellar: :any,                 ventura:       "13e6fac1142d482f01cb233ef9dba93565ebdf676e33939fe8b80d0016843348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5ffccc7b1d0cd97869cdccaa58540ee20516b3920ff0512a3f5d9396020a59"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Forbidden", shell_output("#{bin}/shuttle account 2>&1", 1)
    assert_match "Error: failed to get cargo metadata", shell_output("#{bin}/shuttle deployment status 2>&1", 1)
  end
end
