class Smartdns < Formula
  desc "Rule-based DNS server for fast IP resolution, DoT/DoQ/DoH/DoH3 supported"
  homepage "https://github.com/mokeyish/smartdns-rs"
  url "https://github.com/mokeyish/smartdns-rs/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "369dc4e6ff15fac7065d7c427b8a29d1d45be9487706da1b293b400cffb7be5f"
  license "GPL-3.0-only"
  head "https://github.com/mokeyish/smartdns-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244d246d8f5e3664da41ec1a0e50108cd39b19c7bfa143bbe0424050dd676aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dedc7bf24ccd60d89fc04b457505f992cbfab3727a5b0e1d119da8b0ee9e344"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e41c87a1656335bfdd84192fb9a736a02588f22599aff727667c764423b68f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe8b6284845ed3bcfd5deff619ca4624a8ab7ad0156b9672d2aa038aa4ddaa4"
    sha256 cellar: :any_skip_relocation, ventura:       "ee45a03f89a92484363ef17525d534829130aa632cf93ced9983bdc293a257d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afc1b399898190d0745c2a167553c60bdfcb2e11e5ec6b4533ea739cc1241bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3976c7caa33555f01549a4ef22b8c102165cfd75e1b013757a2c6382573dceb9"
  end

  depends_on "just" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3" => :build # cargo patch
    depends_on "pkgconf" => :build # cargo patch
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "just", "install", "--no-default-features", "--features", "homebrew", *std_cargo_args
    sbin.install bin/"smartdns"
    pkgetc.install "etc/smartdns/smartdns.conf"
  end

  service do
    run [opt_sbin/"smartdns", "run", "-c", etc/"smartdns/smartdns.conf"]
    keep_alive true
    require_root true
  end

  test do
    port = free_port

    (testpath/"smartdns.conf").write <<~EOS
      bind 127.0.0.1:#{port}
      server 8.8.8.8
      local-ttl 3
      address /example.com/1.2.3.4
    EOS
    spawn sbin/"smartdns", "run", "-c", testpath/"smartdns.conf"
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match("example.com.\t\t3\tIN\tA\t1.2.3.4", output)
  end
end
