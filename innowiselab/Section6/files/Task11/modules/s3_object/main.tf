resource "aws_s3_object" "addObjects" {

  count = length(var.key)

  bucket       = var.bucket
  key          = length(var.key) > 1 ? element(var.key, count.index) : var.key[0]
  source       = length(var.sourceTo) > 1 ? element(var.sourceTo, count.index) : var.sourceTo[0]
  content_type = length(var.content_type) > 1 ? element(var.content_type, count.index) : var.content_type[0]

}
