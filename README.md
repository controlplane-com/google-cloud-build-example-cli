# Control Plane - Google Cloud Build Example Using the CLI


This example demonstrates building and deploying an app to Control Plane using the CLI (cpln) as part of a CI/CD pipeline at [Google Cloud Build](https://console.cloud.google.com/cloud-build).

The example is a Node.js app that displays the environment variables and start-up arguments.

This example is provided as a starting point and your own unique delivery and/or deployment requirements will dictate the steps needed in your situation.

## Control Plane Authentication Set Up 

The Control Plane CLI require a `Service Account` with the proper permissions to perform actions against the Control Plane API. 

1. Follow the Control Plane documentation to create a Service Account and create a key. Take a note of the key. It will be used in the next section.
2. Add the Service Account to the `superusers` group. Once the pipeline executes as expected, a policy can be created with a limited set of permissions and the Service Account can be removed from the superusers group.

## Example Set Up

When triggered, the pipeline will execute the steps defined in the `cloudbuild.yaml` file. The example will containerize and push the application to the org's private image repository and create/update a GVC and workload hosted at Control Plane. 

**Perform the following steps to set up the example:**

1. Fork or copy the example into your own workspace at one of the supported Cloud Build repositories.

2. Connect Cloud Build to your workspace and set up the example as a trigger.

3. The following variables are required and must be added as substitution variables within the trigger: 
   
    - `_CPLN_ORG`: Control Plane org.
    - `_CPLN_GVC_NAME`: The name of the GVC.
    - `_CPLN_WORKLOAD_NAME`: The name of the workload.
    - `_CPLN_IMAGE_NAME`: The name of the image that will be deployed. The pipeline will append the short SHA of the commit as the tag when pushing the image to the org's private image repository.

    Substitution variables do not offer the ability the mask sensitive values. Use [Google Secret Manager](https://console.cloud.google.com/security/secret-manager) to create a secret named `CPLN_TOKEN` using the Service Account Key from the previous section. The example uses the secret for authentication. Follow the steps within this [article](https://cloud.google.com/build/docs/securing-builds/use-secrets) to grant permissions to Cloud Build to access the secret values.

4. Review the `cloudbuild.yaml` file: 
    - This file contains the steps that will be executed when the pipeline is triggered.
    - Update line 13 with your PROJECT ID.
    - The script, `cpln.bash` will be executed and perform the following:
      - The Control Plane CLI will be installed. 
      - The sample application will be containerize and pushed to the org's private registry.
      - The `sed` command is used to substitute the `ORG_NAME`, `GVC_NAME`, `WORKLOAD_NAME` and `IMAGE_NAME_TAG` tokens inside the YAML files in the `/cpln` directory.
      - The GVC and Workload will be created/update.

5. The Control Plane YAML files are located in the `/cpln` directory. No changes are required to execute the example.
    - The `cpln-gvc.yaml` file defines the GVC to be created/updated.
    - The `cpln-workload.yaml` file defines the workload to be created/updated. 

6. Run the pipeline using one of the methods specified when creating the trigger.
   
## Running the App

After the pipeline has successfully deployed the application, it can be tested by following these steps:

1. Browse to the Control Plane Console.
2. Select the GVC that was set in the `CPLN_GVC_NAME` variable.
3. Select the workload that was set in the `CPLN_WORKLOAD_NAME` variable.
4. Click the `Open` button. The app will open in a new tab. The container's environment variables and start up arguments will be displayed.


## Notes

* The `cpln apply` command creates and updates the resources defined within the YAML files. If the name of a resource is changed, `cpln apply` will create a new resource. Any orphaned resources will need to be manually deleted.

* The Control Plane CLI commands use the `CPLN_ORG` and `CPLN_TOKEN` environment variables when needed. There is no need to add the --org or --token flags.

* The GVC definition must exists in its own YAML file. The `cpln apply` command executing the file that contains the GVC definition must be executed before any child definition YAML files (workloads, identities, etc.) are executed.


## Helper Links

Google Build

- <a href="https://cloud.google.com/build" target="_blank">Overview</a>
- <a href="https://cloud.google.com/build/docs/securing-builds/use-secrets" target="_blank">Using secrets from Secret Manager</a>
