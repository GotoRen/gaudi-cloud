package main

test_with_credentials {
    msg := `Google provider に対する credentials の指定は非推奨となっています。`
    deny[msg] with input as data.testdata.google_provider_with_credentials
}

test_without_credentials {
    msg := ""
    not deny[msg] with input as data.testdata.google_provider_without_credentials
}
