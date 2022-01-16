require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Mcrypt < AbstractPhp70Extension
  init
  desc "Interface to the mcrypt library"
  homepage "https://php.net/manual/en/book.mcrypt.php"
  revision 20


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  depends_on "phpmcrypt"
  depends_on "libtool" => :build

  def install
    Dir.chdir "ext/mcrypt"

    args = []
    args << "--prefix=#{prefix}"
    args << "--disable-dependency-tracking"
    args << "--with-mcrypt=#{Formula["phpmcrypt"].opt_prefix}"
    args << phpconfig

    cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu
    if OS.mac?
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
    else
      args << "--build=#{cpu}-linux-gnu"
    end

    safe_phpize
    system "./configure", *args
    system "make"
    prefix.install "modules/mcrypt.so"
    write_config_file if build.with? "config-file"
  end
end
