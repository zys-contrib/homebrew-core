class Ldb < Formula
  desc "LDAP-like embedded database"
  homepage "https://ldb.samba.org"
  url "https://download.samba.org/pub/ldb/ldb-2.9.1.tar.gz"
  sha256 "c95e4dc32dea8864b79899ee340c9fdf28b486f464bbc38ba99151a08b493f9b"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://download.samba.org/pub/ldb/"
    regex(/href=.*?ldb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
  depends_on "lmdb"
  depends_on "popt"
  depends_on "talloc"
  depends_on "tdb"
  depends_on "tevent"

  uses_from_macos "python" => :build

  def install
    args = %W[
      --bundled-libraries=NONE
      --disable-python
      --disable-rpath
      --prefix=#{prefix}
    ]
    # Work around undefined symbol "_rep_strtoull"
    args += ["--builtin-libraries=", "--disable-rpath-private-install"] if OS.mac?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test-default-config.ldif").write <<~EOS
      dn: cn=Global,cn=DefaultConfig,cn=Samba
      objectclass: globalconfig
      Workgroup: WORKGROUP
      UnixCharset: UTF8
      Security: user
      NetbiosName: blu
      GuestAccount: nobody

      dn: cn=_default_,cn=Shares,cn=DefaultConfig,cn=Samba
      objectclass: fileshare
      cn: _default_
      Path: /tmp
      ReadOnly: yes
    EOS

    ENV["LDB_URL"] = "test.ldb"
    assert_equal "Added 2 records successfully", shell_output("#{bin}/ldbadd test-default-config.ldif").chomp
    assert_match "returned 1 records", shell_output("#{bin}/ldbsearch '(Path=/tmp)'")
    assert_equal "Modified 1 records successfully", pipe_output("#{bin}/ldbmodify", <<~EOS, 0).chomp
      dn: cn=_default_,cn=Shares,cn=DefaultConfig,cn=Samba
      changetype: modify
      replace: Path
      Path: /temp
    EOS
    assert_match "returned 0 records", shell_output("#{bin}/ldbsearch '(Path=/tmp)'")
    assert_match "returned 1 records", shell_output("#{bin}/ldbsearch '(Path=/temp)'")
  end
end
