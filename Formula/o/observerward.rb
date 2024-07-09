class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2024.7.9.tar.gz"
  sha256 "d41bda274d0572df8062c31effa3f93c35ce7c8409297ee6157b4529de5f6332"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d0b03063faec535754a6f2fac094ec810795fe21e561446201af1bc80ad7a64"
    sha256 cellar: :any,                 arm64_ventura:  "03ba84187c6094cd32fd3eef6f103414e490fc2c47a8c1e292d6a34b5d510076"
    sha256 cellar: :any,                 arm64_monterey: "182966b554fc88782c90901a04e1874c3d875c349831aed709f0265bd03334d5"
    sha256 cellar: :any,                 sonoma:         "5095f0a97fa6b40179dac4fda5ea4034e8f3557511d609a1f8c1d2b927823d56"
    sha256 cellar: :any,                 ventura:        "573b505134078d6fdcfe6397dd3026cc58cdde9b155e18400933245554348a40"
    sha256 cellar: :any,                 monterey:       "cf611a9741288581bb12b464ed0590833c027cafbd1f2a0708c326abb61067df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "868f14053776664346d0452b718a88b90b825a069312a69b3ebfde054747cab1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
