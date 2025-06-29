class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "10efdbaf2bf3e5e1ac672598608ebb434b91aefaf97cd53795f4dcc4e681237b"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d3bdbb3ac123bacf082f21b64b47d1ce8446d508e47f7689be24f3c3a660a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505f8504c7d18a9ba8f5d6c9ae528fa2edd242a2094feec62b7bb126f9041542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59ef51d7ab457559d6d97566853f3ba5dbbe287a2d975fa82040592dff40cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9b260796a9adca5dee9d45a4786b171cf98d16a561a5c8fc2b8d6188666e8e3"
    sha256 cellar: :any_skip_relocation, ventura:       "e322801071ba68af074d6a6362958e4be0a30961fd7eb5f2e515ab9b61aa90b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81753177dc89a6cbbf3cb81c6675a82fdf222e73d2d2629499e860707a957849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761642f503e1155d9dbeba73defb09c225fd0c7aa4ed00796edde600bd0be4b6"
  end

  depends_on "rust" => :build

  # build patch for console 0.16 crate
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end

__END__
diff --git a/autocorrect-cli/Cargo.toml b/autocorrect-cli/Cargo.toml
index d72daf7..9c51524 100644
--- a/autocorrect-cli/Cargo.toml
+++ b/autocorrect-cli/Cargo.toml
@@ -48,6 +48,7 @@ self_update = { version = "0.30.0", features = [
     "rustls",
 ], default-features = false, optional = true }
 sudo = { version = "0.5", optional = true }
+console = { version = "0.16", features = ["std"], default-features = false }

 [features]
 default = ["update"]
