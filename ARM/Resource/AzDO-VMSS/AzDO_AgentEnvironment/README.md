# Introduction 
Drivetrain has some specific requirements, mainly around specific versions of Powershell modules, because of this it is necessary to host managed Azure DevOps Agents created from specific images.  The Azure Image Builder Service is being used to create golden images, that can then be used to create VM's that are always identical between instances.

In order to manage costs and resource utilization, all Azure DevOps Agents are being managed through Virtual Machine Scale Sets, one per major version of the Golden Image being created.

# Getting Started

# Build and Test

# Contribute
