# cyclecloud-adjoin

This is a supporting project to add ActiveDirectory authentication to HPC clusters. The example adjoin-ad.txt template allows to set up a Windows Server with Active Direcotry services.
Keep in mind that the AD server has no proxy; so it should be able to reach the CC server through internal ip.

The pbspro-activedirectory.txt template is an example that has a cluster reference to the above domain server, but this project can also be used to join non-CC managed Active Directories. 
