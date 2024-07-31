class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.7.0.tar.gz"
  sha256 "0a187cb5e4d34fb485ae7ceca77e18b27f22860cf79c03f92e12fc5c2c59c01e"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc7d2d7f3f71d77f3e50c2289d0e6ad2c0a60366c62b14edb24c528ca82cce24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a661457b4af261f7bb57d0587ece4f887f9c27761c39761ddf7678a3bd666e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90bb6b7c2443aeeb7cef0d866577587be5e5751beaec3739873888d736b172c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e1650e60156e1d4a48adf2251dfb9606af718e009f30427745af446820711f8"
    sha256 cellar: :any_skip_relocation, ventura:        "c37a2a52a0b15749b9326617e0a87bac30c68781b074bcbf24cda2818153f1e3"
    sha256 cellar: :any_skip_relocation, monterey:       "693213e919e9ecf7cae4c15a5a5f8cadd47234a9fb3a878d0a084fb72081049b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "184946c5fd1c825722346c58304e3c92d29c433ccedb7d99d9e204fdd32ad2d6"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nickel --version")

    (testpath/"program.ncl").write <<~EOS
      let s = "world" in "Hello, " ++ s
    EOS

    output = shell_output("#{bin}/nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end
