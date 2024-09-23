//【注意】Project Owner ( ren510dev@gmail.com ) 以外のメンバーが変更することを一切禁止します
//
//
//-----------------------------------------------------------------------------
// IAM: k.130.email@gmail.com に開発に必要な最小限の権限を付与する
//-----------------------------------------------------------------------------
resource "google_project_iam_member" "keisuke_ishigami" {
  project = local.project_id
  member  = "user:k.130.email@gmail.com"
  for_each = toset([
    // Global
    "roles/viewer",

    // GKE
    "roles/container.developer",
    // GAR
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    // Monitoring
    "roles/monitoring.editor",
    // Logging
    "roles/logging.admin",
    // Spanner
    "roles/spanner.databaseAdmin",
    "roles/spanner.databaseReader",
    // Memorystore for Redis
    "roles/redis.editor",
    // GCS
    "roles/storage.objectCreator",
    "roles/storage.objectViewer",
    // Cloud Functions
    "roles/cloudfunctions.developer",
    // Firebase
    "roles/firebase.developAdmin",
  ])
  role = each.value
}

//-----------------------------------------------------------------------------
// IAM: srro1991@gmail.com に開発に必要な最小限の権限を付与する
//-----------------------------------------------------------------------------
resource "google_project_iam_member" "ryotaro_suzuki" {
  project = local.project_id
  member  = "user:srro1991@gmail.com"
  for_each = toset([
    // Global
    "roles/viewer",

    // GKE
    "roles/container.developer",
    // GAR
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    // Monitoring
    "roles/monitoring.editor",
    // Logging
    "roles/logging.admin",
    // Spanner
    "roles/spanner.databaseAdmin",
    "roles/spanner.databaseReader",
    // Memorystore for Redis
    "roles/redis.editor",
  ])
  role = each.value
}

//-----------------------------------------------------------------------------
// IAM: minewest065524@gmail.com に開発に必要な最小限の権限を付与する
//-----------------------------------------------------------------------------
resource "google_project_iam_member" "ryota_nishimine" {
  project = local.project_id
  member  = "user:minewest065524@gmail.com"
  for_each = toset([
    // Global
    "roles/viewer",

    // Firebase
    "roles/firebase.developAdmin",
  ])
  role = each.value
}

//-----------------------------------------------------------------------------
// IAM: icoriha.dev@gmail.com に開発に必要な最小限の権限を付与する
//-----------------------------------------------------------------------------
resource "google_project_iam_member" "hiroki_ogata" {
  project = local.project_id
  member  = "user:icoriha.dev@gmail.com"
  for_each = toset([
    // Global
    "roles/viewer",

    // Firebase
    "roles/firebase.developAdmin",
  ])
  role = each.value
}
