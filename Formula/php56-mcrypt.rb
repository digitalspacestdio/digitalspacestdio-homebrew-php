require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Mcrypt < AbstractPhp56Extension
  init
  desc "Interface to the mcrypt library"
  homepage "http://php.net/manual/en/book.mcrypt.php"
  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]
  revision PHP_REVISION

  depends_on "digitalspacestdio/php/phpmcrypt" if OS.linux?
  depends_on "mcrypt" if OS.mac?
  depends_on "libtool" => :build

  def install
    Dir.chdir "ext/mcrypt"

    args = []
    args << "--prefix=#{prefix}"
    args << "--disable-dependency-tracking"
    args << "--with-mcrypt=#{Formula["digitalspacestdio/php/phpmcrypt"].opt_prefix}" if OS.linux?
    args << "--with-mcrypt=#{Formula["mcrypt"].opt_prefix}" if OS.mac?
    args << phpconfig

    safe_phpize
    system "./configure", *args
    system "make"
    prefix.install "modules/mcrypt.so"
    write_config_file if build.with? "config-file"
  end
end
