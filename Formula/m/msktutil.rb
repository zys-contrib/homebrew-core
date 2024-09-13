class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://github.com/msktutil/msktutil"
  url "https://github.com/msktutil/msktutil/releases/download/1.2.2/msktutil-1.2.2.tar.bz2"
  sha256 "51314bb222c20e963da61724c752e418261a7bfc2408e7b7d619e82a425f6541"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7dd1c2cee681040a1952b3fa9059b42ef5776873470629bcc884427a75fad48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ae7002b644fcb64ae57a8a7658040bfd85ece0b3ac155744b713313a8c9ac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4d3885d1ba0b41acce60d176394b766c3ea962e62bc54805f9d3f9d1f647a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1009af38ec21dc0d9bdbd23b6c4c7b40520e5ba34b0cf2f076c9e2d478cc3d58"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a6d9861e56a098e259b1c692024069fb9f6cccce590f99f08019228204886f"
    sha256 cellar: :any_skip_relocation, monterey:       "196311f607cc46b4c213672befdc815a08d046b28508ba3c3f7e6a9f38e5d7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b5dc0137679f966056b649736a3a8e164fd15aad55a283758b6f0a4473f9ecb"
  end

  # macos builtin krb5 has `krb5-config reports unknown vendor Apple MITKerberosShim` error
  depends_on "krb5"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "openldap"

  def install
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/msktutil --version")
  end
end
