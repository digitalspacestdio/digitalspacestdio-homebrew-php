require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php71Ldap < AbstractPhp71Extension
  init
  desc "LDAP Support"
  homepage "https://php.net/manual/en/book.ldap.php"
  revision PHP_REVISION


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484066563dd1230bd27eb151e35f0f8668a2ab4520b3da1446da543b41c08600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "905845609a5223516b2703a06af5b479dd7147d760dd86f39eaed6af61a228a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d0617eb766cc7282edf3f010f7e84fc19777c0db5ab2221072e0e3ab8a5b58"
    sha256 cellar: :any_skip_relocation, monterey:      "5abc17029570bb12ee464572bdd7872f46405c58a5a28003e424a8d2f230bbde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5672853aec42c0ce5d5431bcf660f6c8bfdd3f8b61f77ac2d936d4d61ae2e50"
  end

  depends_on "openldap"

  def install
    Dir.chdir "ext/ldap"
    safe_phpize

    if OS.mac?
      ENV["SASL_CFLAGS"] = "-I#{MacOS.sdk_path_if_needed}/usr/include/sasl"
      ENV["SASL_LIBS"] = "-lsasl2"
      headers_path = "=#{MacOS.sdk_path_if_needed}/usr"
      system "./configure", "--prefix=#{prefix}",
                            phpconfig,
                            "--disable-dependency-tracking",
                            "--with-ldap=#{Formula["openldap"].opt_prefix}",
                            "--with-ldap-sasl#{headers_path}"
    else
      system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--with-ldap=#{Formula["openldap"].opt_prefix}"
    end
    system "make"
    prefix.install "modules/ldap.so"
    write_config_file if build.with? "config-file"
  end
end
