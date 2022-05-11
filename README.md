# sample-interview-app

## Question 1.

If I were to run a `terraform plan` and `terraform apply` at the root of this module...

Can you

- Briefly tell me about what will be deployed?
- Point out any errors you see with the setup, or any violation of terraform best-practices (You can ignore the provider configurations. You can just assume those are correct)

## Question 2.

Can you create the helm chart for the terraform `helm_release.nginx` resource?

It should do the following:

- Utilize the two variables
- All resources should be deployed in the `nginx` namespace
- Create a deployment with one replica running the nginx image
- Should create a service to expose the nginx application on port 3000 (all ports which need to be set are assumed to be on port 3000)
- Utilize the two variables which are set via the `helm_release` resource
- Should install our fake `helper` chart dependency to help expose the application:
  - name: helper
  - version: 0.0.1
  - repository: 'https://github.com/jake-dhcs/helper' (Note, this doesn't actually exist)
- The helper chart needs the following variables set to work properly:
  - applicationName: nginx
  - port: 3000
  - namespace: nginx
