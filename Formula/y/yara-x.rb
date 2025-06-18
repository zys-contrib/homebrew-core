class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  stable do
    url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "f825a24bb2132d284fc9b2bdde1440f6a1f55d699388fee15f859b535e8074e3"

    # patch to fix `elf` module error, upstream commit ref, https://github.com/VirusTotal/yara-x/commit/ae9a6323ff5e6725fac69b76997db82aa53e713a
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "241017c95d97f39e29730d0d51ede05cb5d943934a7d78fa51990a0aff3d9406"
    sha256 cellar: :any,                 arm64_sonoma:  "a3ef596bb84a5f2d0168dcc1079bd261a9ec8cd50646b738ffc9fecc0b15e60a"
    sha256 cellar: :any,                 arm64_ventura: "8d3c52a044cca700e1c1d9e3b2d807f9760adbc513b787ed128994c4928ff504"
    sha256 cellar: :any,                 sonoma:        "85afc2e825ceba6a13e6ff6061be2bdd451af1d8a0293066c8cab13e28ccad77"
    sha256 cellar: :any,                 ventura:       "5f156f595d7860ce0ee015413bc04b38ee4dd348b3cfe714685d0b69948bfa8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7919951cd67ef7d57570c87763581d2c12ce381dc2951ac1e989df24f3bbc90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f036347d37eb1ce446004253bf99ae9de37bf662bfe1a18808bf37802c8a95fe"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "cargo", "cinstall", "-p", "yara-x-capi", "--jobs", ENV.make_jobs.to_s, "--release",
                    "--prefix", prefix, "--libdir", lib

    generate_completions_from_executable(bin/"yr", "completion")
  end

  test do
    # test flow similar to yara
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal <<~EOS.strip, shell_output("#{bin}/yr scan #{rules} #{program}").strip
      chrout #{program}
    EOS

    assert_match version.to_s, shell_output("#{bin}/yr --version")
  end
end

__END__
diff --git a/lib/src/modules/elf/mod.rs b/lib/src/modules/elf/mod.rs
index 5384fcea7..7a38dc4de 100644
--- a/lib/src/modules/elf/mod.rs
+++ b/lib/src/modules/elf/mod.rs
@@ -30,9 +30,11 @@ thread_local!(
 fn main(data: &[u8], _meta: Option<&[u8]>) -> Result<ELF, ModuleError> {
     IMPORT_MD5_CACHE.with(|cache| *cache.borrow_mut() = None);
     TLSH_CACHE.with(|cache| *cache.borrow_mut() = None);
-    parser::ElfParser::new()
-        .parse(data)
-        .map_err(|e| ModuleError::InternalError { err: e.to_string() })
+
+    match parser::ElfParser::new().parse(data) {
+        Ok(elf) => Ok(elf),
+        Err(_) => Ok(ELF::new()),
+    }
 }

 #[module_export]
diff --git a/lib/src/modules/lnk/mod.rs b/lib/src/modules/lnk/mod.rs
index 22f06a3a1..fd73767fe 100644
--- a/lib/src/modules/lnk/mod.rs
+++ b/lib/src/modules/lnk/mod.rs
@@ -18,7 +18,12 @@ pub mod parser;

 #[module_main]
 fn main(data: &[u8], _meta: Option<&[u8]>) -> Result<Lnk, ModuleError> {
-    parser::LnkParser::new()
-        .parse(data)
-        .map_err(|e| ModuleError::InternalError { err: e.to_string() })
+    match parser::LnkParser::new().parse(data) {
+        Ok(lnk) => Ok(lnk),
+        Err(_) => {
+            let mut lnk = Lnk::new();
+            lnk.is_lnk = Some(false);
+            Ok(lnk)
+        }
+    }
 }
