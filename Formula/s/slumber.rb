class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "5fee9f4e2618bb2744646c9265c77daefea2edbc66ef7cc498fc297dea0c370d"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55719bad9086beab7f370e3d408d0edef9a9543231212e6b50cff0ea1bd4b35f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213dbb04f9621f3f39f5839c05cd9043cdadba8cd3f9b243e76490cd7804e79a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2e95b453afca1800a3f911cf339adef3b321bfa21d2982e4d84f61a72811743"
    sha256 cellar: :any_skip_relocation, sonoma:        "8362ad595f031cb3e2cb3d142349922fb7fed8e5df177fcd1b3a043f07f2d595"
    sha256 cellar: :any_skip_relocation, ventura:       "f0fd4c42c49decbab2b779efd389132afa789efc5cda61aa09de99075778d443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9833f40c53f18457e6f7d87722e2f1fcbf510efd440307b20dbb303fd12a40b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8abd9dc7a9582324d40859d38ae0745dd233d634c2382076bddaafbf1f3796a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      # For basic usage info, see:
      # https://slumber.lucaspickering.me/book/getting_started.html
      # For all collection options, see:
      # https://slumber.lucaspickering.me/book/api/request_collection/index.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https://httpbin.org
    YAML
  end
end
