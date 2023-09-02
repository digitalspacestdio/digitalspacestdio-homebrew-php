require File.expand_path("../../Abstract/abstract-php", __FILE__)

class Php82 < AbstractPhp
  init
  desc "PHP Version 8.2"
  include AbstractPhpVersion::Php82Defs
  version PHP_VERSION
  revision 1
  keg_only :versioned_formula
  depends_on "pkg-config" => :build
  depends_on "krb5"
  depends_on "oniguruma"
  depends_on "libjpeg"

  include AbstractPhpVersion::Php82Defs

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  head PHP_GITHUB_URL, :branch => PHP_BRANCH

  def php_version
    "#{PHP_VERSION_MAJOR}"
  end

  def php_version_path
    "#{PHP_BRANCH_NUM}"
  end

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e35d4f9a60e221b953471c31c6494e1afdeed698b3fcc113df4dd448c69c83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a133b33c5099d17ed1bc89c18de1e6578ec586dab98dd027c5e39b622d7e3462"
  end

  def install_args
    args = super
    if !build.without? "pear"
      args << "--with-pear"
    end
    args
  end

  if OS.mac?
      patch do
        url "https://raw.githubusercontent.com/digitalspacestdio/homebrew-php/master/Patches/php74/macos.patch"
        sha256 "53de4079666daabac28358b8a025e3c60103e5b1230c66860c8e0b7414c0fec1"
      end
  end
end
