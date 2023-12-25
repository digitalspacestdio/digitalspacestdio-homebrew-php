require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php72Zip < AbstractPhp72Extension
  init
  desc "Zip"
  homepage "https://www.php.net/manual/ru/book.zip.php"
  revision 1

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4857b0ed27dbf9d2ebaf1b21674f13d6fd11f0b2df6ac962a1c1002033ff9ff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c460ac9e7eb07f889db2bf24b1bacad1731306ba3219ad6fde960158d4fdba6"
    sha256 cellar: :any_skip_relocation, ventura:       "ebc03346c05ccfbb955ca560942d77dd35b1f2964034903f341c3265c3401dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094ffd9071a95419f009475b0ce9748007bfd7ec99096df9fdb11dbe461813bb"
  end

  depends_on "libzip"
  depends_on "zlib"
  depends_on "pkg-config" => :build

  def install
        # Required due to icu4c dependency
    ENV.cxx11

    # icu4c 61.1 compatability
    #ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"
    
    Dir.chdir "ext/zip"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--enable-zip",
                          "--with-libzip=#{Formula["libzip"].opt_prefix}",
                          "--with-zlib-dir=#{Formula["zlib"].opt_prefix}"
    system "make"
    prefix.install "modules/zip.so"
    write_config_file if build.with? "config-file"
  end
end
