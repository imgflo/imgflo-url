# 1.0.0

* Query parameters are now sorted. This might break tests.

# 0.9.0

* Built JavaScript files are no longer checked into git, only included in NPM package.
May cause problems if using bower or component.io package managers; Use browserify instead.

# 0.8.0

* For `.tif` request `.png` output format, since TIFF is poorly supported by browsers (and imgflo).
* Automatically lowercase input extensions like `.JPG` to valid `.jpg` format
* Addded a command-line tool `imgflo-url`, which can be used to construct URLs in scripts etc
