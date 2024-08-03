class Iproute2mac < Formula
  include Language::Python::Shebang

  desc "CLI wrapper for basic network utilities on macOS - ip command"
  homepage "https://github.com/brona/iproute2mac"
  url "https://github.com/brona/iproute2mac/releases/download/v1.5.1/iproute2mac-1.5.1.tar.gz"
  sha256 "cf1359bcaa18b6ccc19d6cdd0562b008d2e9b8a47b33d9d5d35c342d26add11e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b55d4a07c67d7315c47c6f009653d85bc98843f672a3162f09f9434098ff26b"
  end

  depends_on :macos
  depends_on "python@3.12"

  def install
    libexec.install "src/iproute2mac.py"
    libexec.install "src/ip.py" => "ip"
    libexec.install "src/bridge.py" => "bridge"
    rewrite_shebang detected_python_shebang, libexec/"ip", libexec/"bridge", libexec/"iproute2mac.py"
    bin.write_exec_script (libexec/"ip"), (libexec/"bridge")
  end

  test do
    system "/sbin/ifconfig -v -a 2>/dev/null"
    system bin/"ip", "route"
    system bin/"ip", "address"
    system bin/"ip", "neigh"
    system bin/"bridge", "link"
  end
end
