class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.0.0.tar.gz"
  sha256 "7e46f8f55d80bb0e2025a64d5d649af4a4ac21e348020caaadde30ba5e5b4830"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4da9e11c1b59c1c247b94896b6132e57c9bee68f8b3905f2a6e2e7ea48ad70f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65d681b8e330ddfa954cd6f8d0c56863ec5fcf36ac1929864663aef2995d1c35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fda09d099cc70788125425b8b2132ee349af217154176cea40c36487e2ddd259"
    sha256 cellar: :any_skip_relocation, sonoma:         "42f26013f549db73523b909a2a71a8b93bd4105b1161cb807ebc746305af4a1a"
    sha256 cellar: :any_skip_relocation, ventura:        "c1bd81b03a7f9670716425af481221eab826ff57670b03e98d43cdc27c72aa93"
    sha256 cellar: :any_skip_relocation, monterey:       "44e48792931cd817958008d6478b867928fb5f17aa31b4912d323bbf882d9fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fadc84d7c9bfc110074da8348f44bf2f78116302afcb27aa33fb2d815df7158"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.14.2.0.tar.gz"
    sha256 "ddfec5730e5b2f19d0381ecf7f796b39a6e473236bda0ad8d3776a3fe7b07e43"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.6.0.tar.gz"
    sha256 "ba2a27e97c5eb6bd7ca6a0987a8925e44465a5be996daa0d18f8feca37d7571a"
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
