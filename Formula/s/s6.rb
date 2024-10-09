class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.1.0.tar.gz"
  sha256 "bf0614cf52957cb0af04c7b02d10ebd6c5e023c9d46335cbf75484eed3e2ce7e"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "beedd096c77c9b7809ddcd78c6121c50a3142342611a22fe250eeeb47ed2ff1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58518d4c95e24a6b46a44e43916f9c22b7f1257633fc290a5834cc8d9780b4f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37fe43970f0eec3c7898c2b625ef201be5be165e864e496ec92e806026dc64d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec74cd51d621de4e50d4269108c53ddc78eec6923b4869db5853a67edc62a8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2db3595e3a38f9900cc0cb1c843bca72d97c05fb22deb36d524996eeb38c83f"
    sha256 cellar: :any_skip_relocation, ventura:        "fb4abfc1c7be1e3d6545d095f4b2849222a4934748730b57ffdaca48be546fe2"
    sha256 cellar: :any_skip_relocation, monterey:       "0371dba9de65bc315ecab1c2630b5f767a2f03e37eb73c29726eb65680375078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c249fb6a3fba985655871190aab45057a462edca7e92fdacc8e4078fed6f1f"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.14.3.0.tar.gz"
    sha256 "a14aa558c9b09b062fa16acec623b2c8f93d69f5cba4d07f6d0c58913066c427"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.6.1.tar.gz"
    sha256 "76919d62f2de4db1ac4b3a59eeb3e0e09b62bcdd9add13ae3f2dad26f8f0e5ca"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", PATH: "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", PATH: "#{libexec}/execline:$PATH"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
