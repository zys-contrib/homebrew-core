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
    sha256 cellar: :any,                 arm64_sequoia: "8091bed57071a0e879a57e604eff39832ffb904120d1bb34f96666c6c455975a"
    sha256 cellar: :any,                 arm64_sonoma:  "e26f750314254c0b9ec5a2ef5d564b31658577f5a422f940760a8c36111dd475"
    sha256 cellar: :any,                 arm64_ventura: "bc3f6a357cb9f432d7ef56962367f862925c28d286929cebadfff32ad95eb150"
    sha256 cellar: :any,                 sonoma:        "a7b5f6508bd875fe780bfa529c3de5336955cca4cbd168dab2f5857deefbb3ee"
    sha256 cellar: :any,                 ventura:       "c75158ee76e14430ea03f8175941a2a7a3a657780668e9647c24072335692c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd53aea4851259f822ba58d5fa863fa406e71660dc376b9494e7b97b3c9de426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbdf9d8ad0a2561e60172de60f5a44ed2ebc3cfe4e5a518314763e1f0b3e686"
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
