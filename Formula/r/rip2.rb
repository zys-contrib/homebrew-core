class Rip2 < Formula
  desc "Safe and ergonomic alternative to rm"
  homepage "https://github.com/MilesCranmer/rip2"
  url "https://github.com/MilesCranmer/rip2/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e8519e21877c8883f9f2a700036c53bce62b5ee0afaef47a12780999457e2633"
  license "GPL-3.0-or-later"
  head "https://github.com/MilesCranmer/rip2.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rip", "completions")
    (share/"elvish/lib/rip.elv").write Utils.safe_popen_read(bin/"rip", "completions", "elvish")
    (share/"powershell/completions/_rip.ps1").write Utils.safe_popen_read(bin/"rip", "completions", "powershell")
    (share/"nu/completions/rip.nu").write Utils.safe_popen_read(bin/"rip", "completions", "nushell")
  end

  test do
    # Create a test file and verify rip can delete it
    test_file = testpath/"test.txt"
    touch test_file
    system bin/"rip", "--graveyard", testpath/"graveyard", test_file.to_s
    assert_predicate testpath/"graveyard", :exist?
    refute_predicate test_file, :exist?
  end
end
