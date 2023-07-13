locals {
  s3_files = fileset(path.module, "s3_files/*.txt")
}
