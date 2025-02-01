class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "f2bebde21f8f06f726e6c16cd932afa8fe42714012f3ce53b4e0355b7cb91628"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27202dafe7bc5b4ab458a294f03a8874a2d65806ed5b89c1e9c95859855c7ceb"
    sha256 cellar: :any,                 arm64_sonoma:  "0b2c142baaf6765573801d064a9e8617636eaa2cfdd19b077d21fa21d6240637"
    sha256 cellar: :any,                 arm64_ventura: "52d040b9a7eb12451548f5c1974ca57d4d434f9f494d674244fa9b8ae0130ec0"
    sha256 cellar: :any,                 sonoma:        "33f9a88a2a7e9a131edf0ba3decbe2c505ab7427357bb72bc554433c85d6549d"
    sha256 cellar: :any,                 ventura:       "b9c7c9ea2fe582b7db9824418bdf9cdb27c323c4e13d7d29e16eda7093233533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7af786c843b3ddabc4856afa1a82269d5585df4473c702339c0927c6671a39a"
  end

  depends_on "postgresql@17" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-4.29.3.gem"
    sha256 "9a5576c0059f57d7e07107bda8287ac14d0c59c71fe939b260855d3f46b9b566"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.9.gem"
    sha256 "761efbdf73b66516f0c26fcbe6515dc7500c3f0aa1a1b853feae245433c64fdc"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-6.0.0.gem"
    sha256 "fbf09a4e900cee1d61e2bbfda1fefdbc35bc83c5f1c7ae1be1c6ffc5ae0f5c04"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgdexter.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgdexter-#{version}.gem"

    bin.install libexec/"bin/dexter"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      output = shell_output("#{bin}/dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match "Install HypoPG", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
