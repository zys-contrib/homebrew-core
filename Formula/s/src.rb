class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "http://www.catb.org/~esr/src/src-1.40.tar.gz"
  sha256 "8fbeb819945f36712818a528a255179ed888850fce1f339cbe8b7a6c2a9cf5e7"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7583e01995c8b884278faca98e316d051cc467acfcccd13c255952e6e3513bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7583e01995c8b884278faca98e316d051cc467acfcccd13c255952e6e3513bc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7583e01995c8b884278faca98e316d051cc467acfcccd13c255952e6e3513bc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7583e01995c8b884278faca98e316d051cc467acfcccd13c255952e6e3513bc8"
    sha256 cellar: :any_skip_relocation, ventura:        "7583e01995c8b884278faca98e316d051cc467acfcccd13c255952e6e3513bc8"
    sha256 cellar: :any_skip_relocation, monterey:       "7583e01995c8b884278faca98e316d051cc467acfcccd13c255952e6e3513bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e22fce644d8451d5d05072a85737fe8f15cb3c895d5a40c160a8dea615c503bd"
  end

  head do
    url "https://gitlab.com/esr/src.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "rcs"

  uses_from_macos "python", since: :catalina

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    require "pty"
    (testpath/"test.txt").write "foo"
    PTY.spawn("sh", "-c", "#{bin}/src commit -m hello test.txt; #{bin}/src status test.txt") do |r, _w, _pid|
      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match(/^=\s*test.txt/, output)
    end
  end
end
