class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "http://download.camlcity.org/download/findlib-1.9.7.tar.gz"
  sha256 "ccd822008f1b87abd56a12ff7f4af195a0cda2e3bc0113921779a205c9791e29"
  license "MIT"

  livecheck do
    url "http://download.camlcity.org/download/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b87ed1fe983ab11326fec9a012141bd8a3b880354e478dcdef6ab8359e26cbe1"
    sha256 arm64_sonoma:   "27db02a3efa66607b5131c5c7e2fe171540b3967ab0e80da5c62252b2cf8936b"
    sha256 arm64_ventura:  "c9b81ddf8a113a064ef29cc3f0477a608367cec59a87885101ae5ab7063010dd"
    sha256 arm64_monterey: "e37c0b5bf1940cbbc4bfb6406e10d060aa76164bb77d598adf82834a9b725a07"
    sha256 sonoma:         "c7dd3598b58e99b1dfcc4060a1b4bb244e289ae9a13fe98914f29217b5ab67d7"
    sha256 ventura:        "ba4ead7c276b54aa9c48c6e2b929aea8f04a1cbbb808fbfb087a5d9f03fe47ee"
    sha256 monterey:       "5fc964c610117d95d20857f3ffffb52d6f518fe502c74a3ec40e108e60d9e40d"
    sha256 x86_64_linux:   "75203b91c65f7c6ca18a0105202a5a6aeffbd225a4f97fc7a1d977bcaa403f30"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  # Fix to not null parameter `dynlink_subdir`
  # https://github.com/ocaml/ocamlfind/issues/88
  patch :DATA

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX/"lib/ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}/ocaml",
                              "OCAML_CORE_STDLIB=#{lib}/ocaml"

    # Avoid conflict with ocaml-num package
    rm_r(Dir[lib/"ocaml/num", lib/"ocaml/num-top"])

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp
  end
end

__END__
diff --git a/configure b/configure
index a1ca170..07570c0 100755
--- a/configure
+++ b/configure
@@ -502,6 +502,11 @@ check_library () {
         # Library is present - exit code is 0 because the library is found
         # (e.g. detection for Unix) but we don't actually add it to the
         # generated_META list.
+        package_dir="${ocaml_sitelib}/$1"
+        package_subdir="$1"
+        package_key="$(echo "$1" | tr - _)"
+        eval "${package_key}_dir=\"${package_dir}\""
+        eval "${package_key}_subdir=\"${package_subdir}\""
         return 0
     fi
 
