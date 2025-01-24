class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.4/dovecot-2.4.0.tar.gz"
  sha256 "e90e49f8c31b09a508249a4fee8605faa65fe320819bfcadaf2524126253d5ae"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://www.dovecot.org/download/"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6e3f7b7e6aae562c02ddb68a1d7fc39da82f10bad221803a9c60fc60d027ebfc"
    sha256 arm64_sonoma:  "97e1c6443d5546139a4584cc87c80b20d090eb8d228d97774356cdda65c5f278"
    sha256 arm64_ventura: "2152eb14bd601eab60ac6fe646b59665dc73632ae8a8be07fcc6f4c3a8119da2"
    sha256 sonoma:        "81efa1c3b5985fa1ca367731c0229125a798f88c94ff5c3de491f7e832287f9b"
    sha256 ventura:       "cdd2b83bc98d4fe5081cfa0cf1018aa9c329189462786f324946ada25f44497d"
    sha256 x86_64_linux:  "f4f03b65d28a0345273fcee911937a6894980e476c7d6af6bf19d4af77352ae5"
  end

  depends_on "pkgconf" => :build
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtirpc"
    depends_on "linux-pam"
    depends_on "lz4"
    depends_on "xz"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.4/dovecot-pigeonhole-2.4.0.tar.gz"
    sha256 "0ed08ae163ac39a9447200fbb42d7b3b05d35e91d99818dd0f4afd7ad1dbc753"
  end

  # `uoff_t` and `plugins/var-expand-crypt` patches, upstream pr ref, https://github.com/dovecot/core/pull/232
  patch do
    url "https://github.com/dovecot/core/commit/bbfab4976afdf38a7fa966752de33481f9d2c2e5.patch?full_index=1"
    sha256 "f5a77eeaf5978b75a6c7d1d9d4b7623679aec047c3dae63516105774ae6c04de"
  end
  patch :DATA

  def install
    args = %W[
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-ldap
      --with-pam
      --with-sqlite
      --without-icu
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --with-dovecot=#{lib}/dovecot
        --with-ldap
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  service do
    run [opt_sbin/"dovecot", "-F"]
    require_root true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/dovecot/dovecot.log"
    log_path var/"log/dovecot/dovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")

    cp_r share/"doc/dovecot/example-config", testpath/"example"
    (testpath/"example/dovecot.conf").write <<~EOS
      # required in 2.4
      dovecot_config_version = 2.4.0
      dovecot_storage_version = 2.4.0

      base_dir = #{testpath}
      listen = *
      ssl = no

      default_login_user = #{ENV["USER"]}
      default_internal_user = #{ENV["USER"]}

      # reference other conf files
      # !include conf.d/*.conf

      # same as 2.3
      log_path = syslog
      auth_mechanisms = plain
    EOS

    system bin/"doveconf", "-c", testpath/"example/dovecot.conf"
  end
end

__END__
diff --git a/src/lib-var-expand-crypt/Makefile.in b/src/lib-var-expand-crypt/Makefile.in
index 6c8b1ad..b721ad5 100644
--- a/src/lib-var-expand-crypt/Makefile.in
+++ b/src/lib-var-expand-crypt/Makefile.in
@@ -177,7 +177,11 @@ am__uninstall_files_from_dir = { \
 am__installdirs = "$(DESTDIR)$(moduledir)" \
 	"$(DESTDIR)$(pkginc_libdir)"
 LTLIBRARIES = $(module_LTLIBRARIES)
-var_expand_crypt_la_LIBADD =
+var_expand_crypt_la_LIBADD = \
+  ../lib/liblib.la \
+  ../lib-json/libjson.la \
+  ../lib-dcrypt/libdcrypt.la \
+  ../lib-var-expand/libvar_expand.la
 am_var_expand_crypt_la_OBJECTS = var-expand-crypt.lo
 var_expand_crypt_la_OBJECTS = $(am_var_expand_crypt_la_OBJECTS)
 AM_V_lt = $(am__v_lt_@AM_V@)
