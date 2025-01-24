class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-01-20.tar.gz"
  version "2025.01.20"
  sha256 "97b85f52edaff8076a51c259f1d1e706c1f2390a73fec1661c8710a67c53206c"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1860c9fb7950c1b5fabdb497d448f21c7636f23da2ca11e9f883387d3dc71be6"
    sha256 cellar: :any,                 arm64_sonoma:  "2172953a33daf8d11277f9b96d7ab1eab6534c4b5f19f87fa09154fd6ec415f3"
    sha256 cellar: :any,                 arm64_ventura: "0b5a62fc1a2e3c545ae139da4c368f293f5797a11ece3cabb8db65fa9aa4f4e6"
    sha256 cellar: :any,                 sonoma:        "8cb3ca4048f4ba354a3b484b40bcff8e77e09af807bdea677cc63145778cd412"
    sha256 cellar: :any,                 ventura:       "a307fbd0b0fddc5066f967617359f282592cba30c45497b4e260820881294285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "898f977bbe5423b44ca5fb46496be3ed15247d8e87211521044018949e5957f9"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DVCPKG_DEPENDENCY_CMAKERC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end
