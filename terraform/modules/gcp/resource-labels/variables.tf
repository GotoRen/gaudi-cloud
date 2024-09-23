variable "env" {
  type        = string
  description = "必須: 環境を識別する文字列を指定してください"
  default     = "undefined"
}

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

variable "group" {
  type        = string
  description = "任意: オーナーを細分化するグループを示す文字列で、初期値は 'undefined' です"
  default     = "undefined"
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([-a-zA-Z0-9_]*[a-zA-Z0-9])?$", var.group))
    error_message = "Variable 'group' に不正値が指定されています、使用可能文字は '^[a-zA-Z0-9]([-a-zA-Z0-9_]*[a-zA-Z0-9])?$' です"
  }
}

variable "subgroup" {
  type        = string
  description = "任意: グループを細分化するサブグループを示す文字列で、初期値は 'undefined' です"
  default     = "undefined"
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([-a-zA-Z0-9_]*[a-zA-Z0-9])?$", var.subgroup))
    error_message = "Variable 'subgroup' に不正値が指定されています、使用可能文字は '^[a-zA-Z0-9]([-a-zA-Z0-9_]*[a-zA-Z0-9])?$' です"
  }
}

// 任意: 任意のタグ (アンダーバー区切り)
variable "tags" {
  type        = string
  description = "任意: リソースにつけれる任意のタグ情報で、複数指定する場合はアンダーバー区切り (例: abc_efg_hij は abc と efg と hij として扱われる) とします"
  default     = ""
  validation {
    condition     = "" == var.tags || can(regex("^[a-zA-Z0-9]([-a-zA-Z0-9_]*[a-zA-Z0-9])?$", var.tags))
    error_message = "Variable 'tags' に不正値が指定されています、使用可能文字は空文字または '^[a-zA-Z0-9]([-a-zA-Z0-9_]*[a-zA-Z0-9])?$' です"
  }
}
