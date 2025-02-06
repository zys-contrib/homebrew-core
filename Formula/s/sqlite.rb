class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3490000.tar.gz"
  version "3.49.0"
  sha256 "4d8bfa0b55e36951f6e5a9fb8c99f3b58990ab785c57b4f84f37d163a0672759"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56459499fcb30c412b34069af462affba6150a684684b747a7696fb96bd6afe5"
    sha256 cellar: :any,                 arm64_sonoma:  "88f8ceb923134e0f733355ddd5d8aeca284a6749b47bf42dab86de23854b8255"
    sha256 cellar: :any,                 arm64_ventura: "b7aa1674e769996a9fff7a79b81eae73dfcb7c91dd2b746bd2f0c8c9f05ddb4e"
    sha256 cellar: :any,                 sonoma:        "7ca5392892461703f4aaad060a0c33849d95a523e16e7b9e86ec97b94ccd1082"
    sha256 cellar: :any,                 ventura:       "3046ba527c7add5e0406dfb8cdce75a76fa6ba273a3bf0a64041adc2753ef8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8bc3f02f117c74ccf0f315354ccc1ecf10a013c7b2cbc6b7137617f1422a30e"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  # add macos linker patch, upstream discussion, https://sqlite.org/forum/forumpost/a179331cbb
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c797b2d7779960ba443c498c04c02e8a47626f33/sqlite/3.49.0-macos-linker.patch"
    sha256 "d284149cc327be3e5e9a0a7150ce584f5da584e44645ad036b6d2cd143e3e638"
  end

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_API_ARMOR=1
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_DBSTAT_VTAB=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_FTS5=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_STAT4=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
      -DSQLITE_USE_URI=1
    ].join(" ")

    args = [
      "--enable-readline",
      "--disable-editline",
      "--enable-session",
      "--with-readline-cflags=-I#{Formula["readline"].opt_include}",
      "--with-readline-ldflags=-L#{Formula["readline"].opt_lib} -lreadline",
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
