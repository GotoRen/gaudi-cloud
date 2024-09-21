variable "name" {
  type        = string
  description = "必須: リソース名を識別する文字列を指定してください"
  default     = "undefined"
}

variable "owner" {
  type        = string
  description = "必須: オーナーを識別する文字列を指定してください"
  default     = "undefined"
}

variable "env" {
  type        = string
  description = "必須: 環境を識別する文字列を指定してください"
  default     = "undefined"
}
