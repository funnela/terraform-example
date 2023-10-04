Funnela via terraform on AWS
===

This example terraform project allows you to start Funnela on AWS.

Basic setup
---

Make a copy of this project and modify settings in `prepare_state_backend.sh` script. Next run the script - it will prepare terraform state. Next save the script output to `main.tf`. Modify `main.tf` according to you specific needs  and provision infrastructure by running `terraform init` and `terraform apply`.


Funnela is now running on the chosen domain with full production-ready configuration.


Restoring existing DB
---

Follow steps described in `Basic setup`. Next connect to the postgres server running on RDS and replace the `funnela` db by restoring the backup. Restart  docker image on ECS. Database will be automatically updated to the most recent version which is compatible with docker - it might take some time. Use master password to login and change all the passwords. Master password can be found in AWS Parameter Store.
