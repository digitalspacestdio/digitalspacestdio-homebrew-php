require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Tidy < AbstractPhp56Extension
  init
  desc "Tidy HTML clean and repair utility"
  homepage "http://php.net/manual/en/book.tidy.php"
  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]
  revision 6

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3eacc74c10c603ccb4cb85b4e6f83cf6919ce2f8a0e6448bb02295390b1cc60"
  end


  depends_on "digitalspacestdio/php/php-tidy-html5"

  def install
    Dir.chdir "ext/tidy"

    # API compatibility with digitalspacestdio/php/php-tidy-html5 v5.0.0 - https://github.com/htacg/digitalspacestdio/php/php-tidy-html5/issues/224
    inreplace "tidy.c", "buffio.h", "tidybuffio.h"

    # ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-tidy=#{Formula["digitalspacestdio/php/php-tidy-html5"].opt_prefix}"
    system "make"
    prefix.install "modules/tidy.so"
    write_config_file if build.with? "config-file"
  end
end
