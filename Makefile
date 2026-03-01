.PHONY: init validate plan apply clean fmt

init:
	terraform init

validate:
	terraform validate

plan:
	terraform plan -out=d1.tfplan

apply:
	terraform apply d1.tfplan

fmt:
	terraform fmt -recursive .

clean:
	rm -f d1.tfplan d1.tfplan.lock.hcl

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  init       - Initialize Terraform working directory"
	@echo "  validate   - Validate Terraform configuration"
	@echo "  plan       - Create a Terraform plan and save to d1.tfplan"
	@echo "  apply      - Apply the plan from d1.tfplan"
	@echo "  fmt        - Format all Terraform files"
	@echo "  clean      - Remove plan files"
	@echo "  help       - Show this help message"
