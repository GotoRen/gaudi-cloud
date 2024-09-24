package main

# Deny google provider with credentials
deny[msg] {
	cred := input.configuration.provider_config.google.expressions.credentials
	msg := `Google provider に対する credentials の指定は非推奨となっています。`
}
