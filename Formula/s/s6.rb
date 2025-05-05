class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.2.0.tar.gz"
  sha256 "c5114b8042716bb70691406931acb0e2796d83b41cbfb5c8068dce7a02f99a45"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca0aec1300837db9fbafe96ac0d19d937d5f0173d3476a247e809ff6864927e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7188c224c18347b49f04a91fe303123e681704ef108a262330d036dbe57652eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5e99a82c198d22b1a571fb5c422dffd29627bce45b0a9f964a0fcb0cf3ee047"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da05222f6137ef409e26fe0dbf908772c13a68f030fad6d53c273ef0a009534"
    sha256 cellar: :any_skip_relocation, ventura:       "1d903904acbeb5fa6440b6dec1df1d37069ebfda43a52fdc936d47348d7e46f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4531cb9773707e43896925748e312e80c74f33902df3ed8afb45239d6bb92a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a900e9450e59adf25accb3c767706b80e124a941043124e88cccd552af1ba2"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.14.4.0.tar.gz"
    sha256 "0e626261848cc920738f92fd50a24c14b21e30306dfed97b8435369f4bae00a5"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.7.0.tar.gz"
    sha256 "73c9160efc994078d8ea5480f9161bfd1b3cf0b61f7faab704ab1898517d0207"
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
